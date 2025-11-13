import { Container, getContainer } from "@cloudflare/containers";
import { Hono } from "hono";
import { cors } from "hono/cors";
import { bodyLimit } from "hono/body-limit";

export class SparqlingFuseki extends Container<Env> {
  defaultPort = 3030; // Fuseki default port
  sleepAfter = "30m"; // Sleep after 30 minutes of inactivity

  override onStart() {
    console.log("Fuseki container started");
  }

  override onStop() {
    console.log("Fuseki container stopped");
  }

  override onError(error: unknown) {
    console.error("Fuseki container error:", error);
  }
}

/**
 * Create Hono app with proper typing
 */
const app = new Hono<{
  Bindings: Env;
}>();

/**
 * CORS middleware
 */
app.use(
  "*",
  cors({
    origin: "*",
    allowMethods: ["GET", "POST", "OPTIONS"],
    allowHeaders: ["Content-Type", "Authorization"],
  }),
);

/**
 * Body size limit middleware (10KB for SPARQL queries)
 */
app.use(
  "*",
  bodyLimit({
    maxSize: 10 * 1024, // 10KB
    onError: (c) => {
      return c.json(
        { error: "Query too large. Maximum 10KB allowed." },
        413,
      );
    },
  }),
);

/**
 * Block update operations
 */
const blockUpdateOperations = (path: string, method: string) => {
  if (path.includes("/update") || path.includes("/data")) {
    if (method === "POST" || method === "PUT" || method === "DELETE") {
      return true;
    }
  }
  return false;
};

app.all("*", async (c) => {
  const url = new URL(c.req.url);

  // Only allow SPARQL query endpoints
  const allowedPaths = [
    "/sparqling/sparql",
    "/sparqling/query",
    "/sparqling/get",
  ];

  if (!allowedPaths.includes(url.pathname)) {
    return c.json(
      {
        error: "Not found",
        availableEndpoints: {
          sparql: "/sparqling/sparql",
          query: "/sparqling/query",
          get: "/sparqling/get",
        },
      },
      404,
    );
  }

  // Rate limiting
  const ip = c.req.header("CF-Connecting-IP") || "unknown";
  const { success } = await c.env.RATE_LIMITER.limit({ key: ip });

  if (!success) {
    return c.json(
      { error: "Rate limit exceeded. Please try again later." },
      429,
      { "Retry-After": "60" },
    );
  }

  if (blockUpdateOperations(url.pathname, c.req.method)) {
    return c.json({ error: "Update operations are not allowed" }, 403);
  }

  try {
    const container = getContainer(c.env.SPARQLING_FUSEKI, "main");

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 30000);

    const response = await container
      .fetch(c.req.raw, { signal: controller.signal })
      .finally(() => clearTimeout(timeoutId));

    return response;
  } catch (error) {
    console.error("Container error:", error);

    if (error instanceof Error && error.name === "AbortError") {
      return c.json(
        { error: "Query timeout. Please simplify your query." },
        504,
      );
    }

    return c.json({ error: "Internal server error" }, 500);
  }
});

export default app;
