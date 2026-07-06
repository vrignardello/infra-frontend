type PokemonResponse = {
  id: number;
  name: string;
  height: number;
  weight: number;
  base_experience: number;
  sprites: {
    front_default: string | null;
  };
  types: Array<{
    type: {
      name: string;
    };
  }>;
};

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const pokemonId = Number(id);

  if (!Number.isInteger(pokemonId) || pokemonId < 1) {
    return Response.json(
      { error: "Document id must be a positive integer." },
      { status: 400 },
    );
  }

  const response = await fetch(`https://pokeapi.co/api/v2/pokemon/${pokemonId}`, {
    cache: "no-store",
  });

  if (!response.ok) {
    return Response.json(
      { error: `Pokemon API returned ${response.status}.` },
      { status: response.status },
    );
  }

  const pokemon = (await response.json()) as PokemonResponse;

  return Response.json({
    document: {
      id: pokemon.id,
      name: pokemon.name,
      source: "pokeapi.co",
      image: pokemon.sprites.front_default,
      stats: {
        height: pokemon.height,
        weight: pokemon.weight,
        baseExperience: pokemon.base_experience,
      },
      types: pokemon.types.map(({ type }) => type.name),
    },
  });
}
