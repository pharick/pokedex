//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Артем Форкунов on 15.10.2020.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionText: UITextView!

    var pokemon: Pokemon!
    var catched_dict: [String: Int]!
    
    @IBAction func toggleCatch() {
        catched_dict[pokemon.name] = catched_dict[pokemon.name] == 0 ? 1 : 0
        UserDefaults.standard.set(catched_dict, forKey: "catched")
        catchButton.setTitle(catched_dict[pokemon.name] != 0 ? "Release" : "Catch", for: UIControl.State.normal)
    }
    
    func setCatch() {
        catched_dict = UserDefaults.standard.object(forKey: "catched") as? [String: Int] ?? [:]
        
        if catched_dict[pokemon.name] == nil {
            catched_dict[pokemon.name] = 0
            UserDefaults.standard.set(catched_dict, forKey: "catched")
        }
        
        catchButton.setTitle(catched_dict[pokemon.name] != 0 ? "Release" : "Catch", for: UIControl.State.normal)
    }
    
    func getImage(_ url: String) {
        let imageUrl = URL(string: url)
        guard let u = imageUrl else {
            return
        }

        guard let imageData = try? Data(contentsOf: u) else {
            return
        }

        let image = UIImage(data: imageData)
        
        DispatchQueue.main.async {
            self.imageView.image = image;
        }
    }
    
    func getDescription(_ id: Int) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)/")
        guard let u = url else {
            return
        }
        
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let pokemonSpeciesData = try JSONDecoder().decode(PokemonSpeciesData.self, from: data)
                
                for entry in pokemonSpeciesData.flavor_text_entries {
                    if entry.language.name == "en" {
                        DispatchQueue.main.async {
                            self.descriptionText.text = entry.flavor_text.replacingOccurrences(of: "\n", with: " ")
                        }

                        break
                    }
                }
            } catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type1Label.text = ""
        type2Label.text = ""
        
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }

        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)

                DispatchQueue.main.async {
                    self.nameLabel.text = self.pokemon.name
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        } else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
                
                self.getImage(pokemonData.sprites.front_default)
                self.getDescription(pokemonData.id)
            } catch let error {
                print("\(error)")
            }
        }.resume()
        
        setCatch()
    }
}
