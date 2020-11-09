//
//  ChallengeProtocol.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 28/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

protocol ChallengeProtocol {
    func didUpdateSightedStatus(unsightedFrogEntity: UnSightedFrogEntity, status: Bool)
}
