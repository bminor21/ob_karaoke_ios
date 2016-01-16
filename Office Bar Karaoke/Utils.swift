//
//  Utils.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 1/15/16.
//  Copyright © 2016 Brett Minor. All rights reserved.
//

import Foundation

// MARK: - String Functions
func prepareURLString(str: String, searchType: String ) -> String {
    let temp = searchType.stringByAppendingString("=")
    var formattedString = str
    
    if( searchType != "all" ){
        formattedString = formatString(formattedString)
    } else {
        formattedString = "true";
    }
    
    return temp.stringByAppendingString(formattedString)
}

func formatString( toFormat: String)-> String {
    var formattedString:String!
    
    let chars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890'".characters)
    formattedString = String(toFormat.characters.filter { chars.contains($0) })
    formattedString = formattedString.stringByTrimmingCharactersInSet(
        NSCharacterSet.whitespaceAndNewlineCharacterSet()
    )
    formattedString = formattedString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    
    return formattedString
}