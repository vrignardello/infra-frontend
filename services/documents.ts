import { headers } from "next/headers";

export type DocumentResponse = {
  document: {
    id: number;
    name: string;
    source: string;
    image: string | null;
    stats: {
      height: number;
      weight: number;
      baseExperience: number;
    };
    types: string[];
  };
};

function getRequestOrigin(headersList: Headers) {
  const host = headersList.get("host");
  const protocol = headersList.get("x-forwarded-proto") ?? "http";

  if (!host) {
    throw new Error("Unable to resolve request host.");
  }

  return `${protocol}://${host}`;
}

export async function getDocument(id: number): Promise<DocumentResponse> {
  const headersList = await headers();
  const origin = getRequestOrigin(headersList);
  const response = await fetch(`${origin}/api/documents/${id}`, {
    cache: "no-store",
  });

  if (!response.ok) {
    throw new Error(`Document API returned ${response.status}.`);
  }

  return response.json() as Promise<DocumentResponse>;
}
