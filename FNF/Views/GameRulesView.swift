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
                        description: "Igra se odvija na tabli od 10 redova i 6 kolona. Svaka ćelija može sadržati broj od 1-9, power-up ili biti prazna."
                    )
                    RuleRow(
                        title: "Cilj igre",
                        description: "Ostvari ciljni broj u redu ili koloni da bi osvojio poene. Ciljni broj se povećava sa nivoom."
                    )
                    RuleRow(
                        title: "Padajući brojevi",
                        description: "Brojevi padaju sa vrha table. Možeš videti sledeći broj koji će pasti."
                    )
                }
                
                // Kontrole
                Section(header: Text("Kontrole")) {
                    RuleRow(
                        title: "Pomeranje",
                        description: "Koristi strelice za pomeranje brojeva levo i desno u okviru kolone."
                    )
                    RuleRow(
                        title: "Rotacija",
                        description: "Koristi dugme za rotaciju da bi zamenio trenutni i sledeći broj."
                    )
                    RuleRow(
                        title: "Ubrzavanje",
                        description: "Drži dugme za ubrzavanje pada broja."
                    )
                }
                
                // Power-upovi
                Section(header: Text("Power-upovi")) {
                    RuleRow(
                        title: "×2 (Multiplier)",
                        description: "Udvostručuje vrednost kombo multiplikatora. Koristi ga kada imaš dobar kombo."
                    )
                    RuleRow(
                        title: "🎲 (Randomizer)",
                        description: "Nasumično menja sve brojeve na tabli. Koristi ga kada ti nedostaje mali broj za cilj."
                    )
                    RuleRow(
                        title: "→ (Clear Row)",
                        description: "Briše ceo red. Koristi ga kada je red blizu ciljnog broja."
                    )
                    RuleRow(
                        title: "↓ (Clear Column)",
                        description: "Briše celu kolonu. Koristi ga kada je kolona blizu ciljnog broja."
                    )
                }
                
                // Kombo sistem
                Section(header: Text("Kombo sistem")) {
                    RuleRow(
                        title: "Kombo multiplikator",
                        description: "Svaki uspešan potez povećava kombo multiplikator (maksimalno 5x). Kombo se resetuje kada ne očistiš nijednu liniju."
                    )
                    RuleRow(
                        title: "Višestruko čišćenje",
                        description: "Očisti više redova ili kolona odjednom za veći kombo i više poena."
                    )
                    RuleRow(
                        title: "Poeni",
                        description: "Poeni = broj obrisanih linija × 100 × kombo multiplikator"
                    )
                }
                
                // Režimi igre
                Section(header: Text("Režimi igre")) {
                    RuleRow(
                        title: "Klasični",
                        description: "Igraj dok ne izgubiš. Ciljni broj se povećava sa nivoom. Svakih 500 poena napreduješ nivo."
                    )
                    RuleRow(
                        title: "Time Attack",
                        description: "Igraj protiv vremena. Dobijaš 50% više poena. Brži je i izazovniji."
                    )
                    RuleRow(
                        title: "Zen",
                        description: "Opuštajući režim bez vremena i game over-a. Savršen za vežbanje."
                    )
                }
                
                // Saveti
                Section(header: Text("Saveti")) {
                    RuleRow(
                        title: "Planiranje",
                        description: "Planiraj svoje poteze unapred. Gledaj sledeći broj i razmišljaj kako ćeš ga iskoristiti."
                    )
                    RuleRow(
                        title: "Power-upovi",
                        description: "Štedi power-upove za teške situacije. ×2 je najbolji za kombo, a Randomizer za izlazak iz problema."
                    )
                    RuleRow(
                        title: "Kombo",
                        description: "Pokušaj da održiš kombo što duže. Čišćenje više linija odjednom je ključ za visok skor."
                    )
                    RuleRow(
                        title: "Brzina",
                        description: "Igra postaje brža sa nivoom. Budi spreman i reaguj brzo."
                    )
                }
                
                // Game Over
                Section(header: Text("Game Over")) {
                    RuleRow(
                        title: "Kraj igre",
                        description: "Igra se završava kada padajući broj ne može da se zaustavi ni u jednom redu."
                    )
                    RuleRow(
                        title: "Najbolji skor",
                        description: "Pokušaj da oboriš svoj najbolji skor. Svaka partija je nova prilika."
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