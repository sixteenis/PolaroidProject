//
//  SelectProfileViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation

final class SelectProfileViewModel {
    var inputSelectProfile: Obsearvable<Int?> = Obsearvable(nil)
    
    var outputProfileImage: Obsearvable<String?> = Obsearvable(nil)
    
    init() {
        inputSelectProfile.bind { [weak self] index in
            guard let index, let self else { return }
            self.getprofileImage(index)
        }
    }
    
    private func getprofileImage(_ index: Int) {
        outputProfileImage.value = ProfileImage.allCases[index].image
    }
    
}
