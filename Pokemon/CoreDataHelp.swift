//
//  CoreDataHelp.swift
//  Pokemon
//
//  Created by Apple on 7/22/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func addAllPokemon() {

    createPokemon(name: "Mew", image: "mew")
    createPokemon(name: "Pikachu", image: "pikachu")
    createPokemon(name: "Psyduck", image: "psyduck")
    createPokemon(name: "Rattata", image: "rattata")
    createPokemon(name: "Snorlax", image: "snorlax")
    createPokemon(name: "Squirtle", image: "squirtle")
    createPokemon(name: "Tornado", image: "tornado")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

func createPokemon(name:String, image:String) {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.image = image
    
}

func getAllPokemon() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
    let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
            
        }
        return pokemons
    }catch {}
    
    return []
    
}

func getAllCaughtPokemons() -> [Pokemon] {
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = (Pokemon.fetchRequest()) as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)

    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
    
        return pokemons
    }catch {}
    
    return []
    
}

func getAllUncaughtPokemons() -> [Pokemon] {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = (Pokemon.fetchRequest()) as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        
        return pokemons
    }catch {}
    
    return []
    
}


