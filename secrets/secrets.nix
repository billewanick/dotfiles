let
  bill-github = "blah";
  bill-gitlab = "blah2";
  bill-jonringer = "";
  my-keys = [
    bill-github
    bill-gitlab
    bill-jonringer
  ];

in
{
  "secret1.age".publicKeys = [ my-keys ];
}
