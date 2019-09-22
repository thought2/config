let
  c = builtins.fromJSON (builtins.readFile ./refs.json);
in
{
   a = c.url;
}
