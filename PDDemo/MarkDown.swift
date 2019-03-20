//
//  MarkDown.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 06/03/2019.
//  Copyright © 2019 pddemo. All rights reserved.
//
//  Extends the markymark framework to allow inline images to be retrieved from cache
import Foundation
import markymark

extension MarkyMark {
    
    //Convert MarkDown to AttributedString
    static func getAttributedContent(from content: String, styling: Styling = DefaultStyling()) -> NSAttributedString {
        
        //Init instance and parse
        let markyMark = MarkyMark() { $0.setFlavor(ContentfulFlavor()) }
        let markdownItems = markyMark.parseMarkDown(content)
        //Convert to markdown
        let config = MarkDownToAttributedStringConverterConfiguration(styling: styling)
        let converter = MarkDownConverter(configuration: config)
        let attributedText = converter.convert(markdownItems)
        
        return attributedText
        
    }
    
    //Asynchronous version of function Convert MarkDown to AttributedString
    //Initial return value returns an attributed string without attachments which can be shown immediately
    //Completion handler will be called when full version (including attachments) returns
    static func getAttributedContent(from content: String, completion: @escaping ((NSAttributedString)->Void), styling: Styling = DefaultStyling()) -> NSAttributedString {
        
        //Check we have content to convert, if not return empty attributed string
        let markyMark = MarkyMark() { $0.setFlavor(ContentfulFlavor()) }
        let markdownItems = markyMark.parseMarkDown(content)
        
        //Filter out any images for now
        let markdownNoImages = markdownItems.filter() { !($0 is ImageBlockMarkDownItem)}
        let config = MarkDownToAttributedStringConverterConfiguration(styling: styling)
        let converter = MarkDownConverter(configuration: config)
        let attributedTextNoImages = converter.convert(markdownNoImages)
        
        //Asynchronously get images
        DispatchQueue.global(qos: .userInitiated).async {
            let config = MarkDownToAttributedStringConverterConfiguration(styling: styling)
            let converter = MarkDownConverter(configuration: config)
            let attributedTextWithImages = converter.convert(markdownItems)
            //Call completion handler on background thread, which must then sync with main for UI work
            completion(attributedTextWithImages)
        
        }
        
        //Return text without images
        return attributedTextNoImages
        
    }
}
