//
//  FOTokenTextView+Delegates.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-10-15.
//
//

extension FOTokenTextView: UITextViewDelegate {
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            var should = true
            
            if let s = tokenDelegate?.shouldAddOnReturn(self.text) {
                should = s
            }
            
            if should {
                addToken(self.text)
                self.text = nil
            }
            
            return false
        }
        
        if text.characters.count == 0 && textView.text.characters.count == 0 {
            var should = true
            
            if let token = tokens.last {
                if let s = tokenDelegate?.shouldRemoveOnDelete(token) {
                    should = s
                }
            }
            
            if should {
                doDelete()
            }
            
            return false
        }
        
        clearSelectedToken()
        
        return true
    }
    
    public func textViewDidChange(textView: UITextView) {
        if debug {
            setNeedsDisplay()
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset = CGPointZero
    }
    
}

extension FOTokenTextView: NSLayoutManagerDelegate {
    
    public func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return heightOffset()
    }
    
}

