//
//  DataPickerImplementation.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 25.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DataPickerImplementation: DataPicker {

    static let shared = DataPickerImplementation()

    private init () {}
    private var delegates: [ImagePickerDelegate] = []

    func tryToFetchImage(vc: UIViewController, completion: @escaping ImageFetchCompletion) {
        let imagePickerController = UIImagePickerController()

        let delegate = ImagePickerDelegate()
        delegate.completion = { [weak self] in
            self?.delegates.removeAll(where: { $0 == delegate })
            completion($0)
        }

        delegates.append(delegate)

        imagePickerController.delegate = delegate
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.allowsEditing = true

        vc.present(imagePickerController, animated: true, completion: nil)
    }

}

private class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var completion: ImageFetchCompletion?

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        completion?(image)
    }

}
