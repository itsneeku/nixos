{
  # nix flake init -t $"($env.FLAKE)#c"
  c.path = ./c;

  deno.path = ./deno;

  node.path = ./node;
}
