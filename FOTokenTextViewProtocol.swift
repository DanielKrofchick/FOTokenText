//
//  FOTokenTextViewProtocol.swift
//  FOTokenText
//
//  Created by Daniel Krofchick on 2018-10-08.
//

public protocol FOTokenTextViewProtocol {
    func newToken(_ textView: FOTokenTextView, text: String) -> FOTokenView
    func didRemove(_ token: FOTokenView)
    func didAdd(_ token: FOTokenView)
    func shouldRemoveOnDelete(_ token: FOTokenView) -> Bool
    func shouldAddOnReturn(_ text: String) -> Bool
}

public extension FOTokenTextViewProtocol {
    func didRemove(_ token: FOTokenView) {
    }
    
    func didAdd(_ token: FOTokenView) {
    }
    
    func shouldRemoveOnDelete(_ token: FOTokenView) -> Bool {
        return true
    }
    
    func shouldAddOnReturn(_ text: String) -> Bool {
        return true
    }
}
