# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TlcApp.Repo.insert!(%TlcApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
TlcApp.Repo.insert(%TlcApp.School.Course{name: "ADVANCE AUDIT AND ASSURANCE", code: "AAA"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "CORPORATE REPORTING", code: "CR"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "ADVANCE TAXATION", code: "ATAX"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "STRATEGIC FINANCIAL MANAGEMENT", code: "SFM"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "CASE STUDY", code: "CS"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "AUDIT AND ASSURANCE", code: "AA"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "FINANCIAL REPORTING", code: "FR"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "TAXATION", code: "TAX"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "MANAGEMENT, GOVERNANCE AND ETHICS", code: "MGE"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "PUBLIC SECTOR ACCOUNTING", code: "PSA"})
TlcApp.Repo.insert(%TlcApp.School.Course{name: "PROJECT MANAGEMENT", code: "PM"})
