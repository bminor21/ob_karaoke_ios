//
//  Utils.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 1/15/16.
//  Copyright © 2016 Brett Minor. All rights reserved.
//

import Foundation

// MARK: - String Functions
func prepareURLString(_ str: String, searchType: String ) -> String {
    let temp = searchType + "="
    var formattedString = str
    
    if( searchType != "all" ){
        formattedString = formatString(formattedString)
    } else {
        formattedString = "true";
    }
    
    return temp + formattedString
}

func formatString( _ toFormat: String)-> String {
    var formattedString:String!
    
    let chars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890'".characters)
    formattedString = String(toFormat.characters.filter { chars.contains($0) })
    formattedString = formattedString.trimmingCharacters(
        in: CharacterSet.whitespacesAndNewlines
    )
    formattedString = formattedString.addingPercentEscapes(using: String.Encoding.utf8)!
    
    return formattedString
}
