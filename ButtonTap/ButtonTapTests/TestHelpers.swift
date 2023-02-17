//
//  TestHelpers.swift
//  ButtonTapTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import UIKit

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}
