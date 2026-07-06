import { getDocument } from "@/services/documents";

export default async function Home() {
  const document = await getDocument(1);
  const formattedDocument = JSON.stringify(document, null, 2);

  return (
    <main className="min-h-screen bg-zinc-50 px-6 py-10 text-zinc-950 dark:bg-zinc-950 dark:text-zinc-50 sm:px-10">
      <section className="mx-auto flex w-full max-w-4xl flex-col gap-6">
        <div className="flex flex-col gap-3">
          <p className="text-sm font-medium text-zinc-500 dark:text-zinc-400">
            SSR moderno con App Router
          </p>
          <h1 className="text-3xl font-semibold tracking-normal sm:text-4xl">
            Respuesta desde /api/documents/1
          </h1>
          <p className="max-w-2xl text-base leading-7 text-zinc-600 dark:text-zinc-300">
            Esta página es un Server Component async. En el servidor llama al
            service, el service consume el Route Handler interno y el Route
            Handler obtiene datos desde PokeAPI.
          </p>
        </div>

        <pre className="overflow-x-auto rounded-lg border border-zinc-200 bg-white p-5 text-sm leading-6 text-zinc-800 shadow-sm dark:border-zinc-800 dark:bg-zinc-900 dark:text-zinc-100">
          <code>{formattedDocument}</code>
        </pre>
      </section>
    </main>
  );
}
