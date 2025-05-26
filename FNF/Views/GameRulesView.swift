import SwiftUI

struct GameRulesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Osnovna pravila
                Section(header: Text("Osnovna pravila")) {
                    RuleRow(
                        title: "Tabla za igru",
                        description: "Igra se odvija na tabli od 10 redova i 6 kolona. Svaka ćelija može sadržati broj od 1-9, power-up ili biti prazna. Brojevi padaju sa vrha table i moraju se postaviti u prazne ćelije."
                    )
                    RuleRow(
                        title: "Cilj igre",
                        description: "Ostvari ciljni broj u redu ili koloni da bi osvojio poene. Ciljni broj se povećava sa nivoom (počinje od 10 i može doseći do 20). Svakih 500 poena napreduješ nivo."
                    )
                    RuleRow(
                        title: "Padajući brojevi",
                        description: "Brojevi padaju sa vrha table. Možeš videti sledeći broj koji će pasti. Verovatnoća za power-up je 10%. Brojevi se kreću od 1 do 9."
                    )
                }
                
                // Kontrole
                Section(header: Text("Kontrole")) {
                    RuleRow(
                        title: "Pomeranje",
                        description: "Koristi strelice za pomeranje brojeva levo i desno u okviru kolone. Broj se može pomerati samo dok pada."
                    )
                    RuleRow(
                        title: "Rotacija",
                        description: "Koristi dugme za rotaciju da bi zamenio trenutni i sledeći broj. Ovo je ključna mehanika za planiranje poteza."
                    )
                    RuleRow(
                        title: "Ubrzavanje",
                        description: "Drži dugme za ubrzavanje pada broja. Brzina pada se povećava 5 puta. Koristi ovo kada želiš brže da postaviš broj."
                    )
                }
                
                // Power-upovi
                Section(header: Text("Power-upovi")) {
                    RuleRow(
                        title: "×2 (Multiplier)",
                        description: "Udvostručuje vrednost kombo multiplikatora. Koristi ga kada imaš dobar kombo za maksimalne poene. Efekat traje do sledećeg čišćenja."
                    )
                    RuleRow(
                        title: "🎲 (Randomizer)",
                        description: "Nasumično menja sve brojeve na tabli. Koristi ga kada ti nedostaje mali broj za cilj ili kada je tabla blizu prekoračenja."
                    )
                    RuleRow(
                        title: "→ (Clear Row)",
                        description: "Briše ceo red. Koristi ga kada je red blizu ciljnog broja ili kada želiš da napraviš mesta za nove brojeve."
                    )
                    RuleRow(
                        title: "↓ (Clear Column)",
                        description: "Briše celu kolonu. Koristi ga kada je kolona blizu ciljnog broja ili kada želiš da napraviš mesta za nove brojeve."
                    )
                }
                
                // Kombo sistem
                Section(header: Text("Kombo sistem")) {
                    RuleRow(
                        title: "Kombo multiplikator",
                        description: "Svaki uspešan potez povećava kombo multiplikator (maksimalno 5x). Kombo se resetuje ako ne očistiš nijednu liniju u roku od 5 sekundi."
                    )
                    RuleRow(
                        title: "Višestruko čišćenje",
                        description: "Očisti više redova ili kolona odjednom za veći kombo i više poena. Svaka dodatna linija povećava kombo multiplikator."
                    )
                    RuleRow(
                        title: "Poeni",
                        description: "Poeni = broj obrisanih linija × 100 × kombo multiplikator. U Time Attack modu, poeni se množe sa 1.5."
                    )
                }
                
                // Režimi igre
                Section(header: Text("Režimi igre")) {
                    RuleRow(
                        title: "Klasični",
                        description: "Igraj dok ne izgubiš. Ciljni broj se povećava sa nivoom. Svakih 500 poena napreduješ nivo. Brzina pada se povećava sa nivoom."
                    )
                    RuleRow(
                        title: "Time Attack",
                        description: "Igraj protiv vremena. Dobijaš 50% više poena. Brži je i izazovniji. Igra se završava kada istekne vreme."
                    )
                    RuleRow(
                        title: "Zen",
                        description: "Opuštajući režim bez vremena i game over-a. Ciljni broj ostaje konstantan. Savršen za vežbanje i učenje mehanika."
                    )
                }
                
                // Saveti
                Section(header: Text("Saveti")) {
                    RuleRow(
                        title: "Planiranje",
                        description: "Planiraj svoje poteze unapred. Gledaj sledeći broj i razmišljaj kako ćeš ga iskoristiti. Rotacija je ključna za dobro planiranje."
                    )
                    RuleRow(
                        title: "Power-upovi",
                        description: "Štedi power-upove za teške situacije. ×2 je najbolji za kombo, a Randomizer za izlazak iz problema. Clear Row/Column su odlični za čišćenje mesta."
                    )
                    RuleRow(
                        title: "Kombo",
                        description: "Pokušaj da održiš kombo što duže. Čišćenje više linija odjednom je ključ za visok skor. Imaj na umu 5-sekundni timeout za kombo."
                    )
                    RuleRow(
                        title: "Brzina",
                        description: "Igra postaje brža sa nivoom. Koristi ubrzavanje pada kada je potrebno, ali budi oprezan. Brže reagovanje je ključno za visoke skorove."
                    )
                }
                
                // Game Over
                Section(header: Text("Game Over")) {
                    RuleRow(
                        title: "Kraj igre",
                        description: "Igra se završava kada padajući broj ne može da se zaustavi ni u jednom redu. U Time Attack modu, igra se završava i kada istekne vreme."
                    )
                    RuleRow(
                        title: "Savršena igra",
                        description: "Završi igru bez grešaka da bi dobio dodatne poene i dostignuće. Savršena igra se računa kada ne napraviš nijednu grešku i postigneš pozitivan skor."
                    )
                    RuleRow(
                        title: "Najbolji skor",
                        description: "Pokušaj da oboriš svoj najbolji skor. Svaka partija je nova prilika. Fokusiraj se na održavanje komba i efikasno korišćenje power-upova."
                    )
                }
            }
            .navigationTitle("Pravila igre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zatvori") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct RuleRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    GameRulesView()
} 