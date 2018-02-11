# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WeeklyPickem.Repo.insert!(%WeeklyPickem.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WeeklyPickem.Repo
alias WeeklyPickem.Model.Team
alias WeeklyPickem.Model.Match
alias WeeklyPickem.Model.Pick
alias WeeklyPickem.Model.User


%Team{name: "Team Solo Mid"} |> Repo.insert!
%Team{name: "Counter Logic Gaming"} |> Repo.insert!
%Team{name: "One Thousand Theifs"} |> Repo.insert!
