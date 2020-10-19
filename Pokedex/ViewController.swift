//
//  ViewController.swift
//  Pokedex
//
//  Created by Артем Форкунов on 14.10.2020.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    var pokemon: [Pokemon] = []
    var filteredPokemon: [Pokemon] = []
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == "" {
            filteredPokemon = pokemon
        } else {
            filteredPokemon = pokemon.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                self.filteredPokemon = self.pokemon
            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("\(error)")
            }
        }.resume()
        
        searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: filteredPokemon[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = filteredPokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

