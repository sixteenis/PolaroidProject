//
//  LoginViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private var profileImage = MainProfileImageView()
    private let line = UIView()
    private let nicknameTextField = UITextField()
    private let textLine = UIView()
    private let nicknameFilterLabel = UILabel()
    
    private let mbtiLabel = UILabel()
    
    private let mbtiEIButton = MBTIButtonView(frame: .zero, top: "E", bottom: "I", buttonIndex: 0)
    private let mbtiSNButton = MBTIButtonView(frame: .zero, top: "S", bottom: "N", buttonIndex: 1)
    private let mbtiTFButton = MBTIButtonView(frame: .zero, top: "T", bottom: "F", buttonIndex: 2)
    private let mbtiJPButton = MBTIButtonView(frame: .zero, top: "J", bottom: "P", buttonIndex: 3)
    
    private var successButton = SuccessButton("완료", bool: false)
    private let resetButton = UIButton()
    
    
    
    
    
    let vm = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mbtiCompletionSet()
        vm.inputViewDidLoade.value = ()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    // MARK: - vm 부분
    override func bindData() {
        vm.outputProfileImage.bind { [weak self] image in
            guard let self, let image else { return }
            self.profileImage.changeProfile(image)
        }
        vm.outputFilterTitle.bind { [weak self] result in
            guard let self else { return }
            self.nicknameFilterLabel.text = result.rawValue
            self.nicknameFilterLabel.textColor = result.color
        }
        vm.outputFilterBool.bind(true) { [weak self] bool in
            guard let self else {return}
            self.successButton.toggleColor(bool)
            self.successButton.isEnabled = bool
        }
        vm.outputMBTICheck.bind { [weak self] bools in
            guard let self else { return }
            self.mbtiEIButton.buttonChange(bools[0])
            self.mbtiSNButton.buttonChange(bools[1])
            self.mbtiTFButton.buttonChange(bools[2])
            self.mbtiJPButton.buttonChange(bools[3])
        }
        //        vm.outputProfileImage.bind { image in
        //            self.profileImage.changeImage(image)
        //        }
        //        vm.outputFilterTitle.bind { data in
        //            self.nicknameFilterLabel.text = data.rawValue
        //            self.nicknameFilterLabel.textColor = data.color
        //        }
        
    }
    // MARK: - connect 부분
    override func setUpHierarchy() {
        view.addSubview(line)
        view.addSubview(profileImage)
        view.addSubview(nicknameTextField)
        view.addSubview(textLine)
        view.addSubview(nicknameFilterLabel)
        view.addSubview(successButton)
        view.addSubview(resetButton)
        view.addSubview(mbtiLabel)
        view.addSubview(mbtiEIButton)
        view.addSubview(mbtiSNButton)
        view.addSubview(mbtiTFButton)
        view.addSubview(mbtiJPButton)
        
        //델리게이트
        nicknameTextField.delegate = self
        
        successButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tap)
    }
    
    // MARK: - Layout 부분
    override func setUpLayout() {
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(view.snp.width).multipliedBy(0.3)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        textLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(1)
        }
        nicknameFilterLabel.snp.makeConstraints { make in
            make.top.equalTo(textLine.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        mbtiLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(textLine.snp.bottom).offset(40)
        }
        mbtiEIButton.snp.makeConstraints { make in
            make.top.equalTo(textLine.snp.bottom).offset(40)
            make.height.equalTo(100)
            make.width.equalTo(50)
            make.trailing.equalTo(mbtiSNButton.snp.leading).offset(-5)
        }
        mbtiSNButton.snp.makeConstraints { make in
            make.top.equalTo(textLine.snp.bottom).offset(40)
            make.height.equalTo(100)
            make.width.equalTo(50)
            make.trailing.equalTo(mbtiTFButton.snp.leading).offset(-5)
        }
        mbtiTFButton.snp.makeConstraints { make in
            make.top.equalTo(textLine.snp.bottom).offset(40)
            make.height.equalTo(100)
            make.width.equalTo(50)
            make.trailing.equalTo(mbtiJPButton.snp.leading).offset(-5)
        }
        mbtiJPButton.snp.makeConstraints { make in
            make.top.equalTo(textLine.snp.bottom).offset(40)
            make.height.equalTo(100)
            make.width.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        successButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - UI 세팅 부분
    override func setUpView() {
        navigationController?.navigationBar.tintColor = .cBlack
        //        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        //        navigationItem.leftBarButtonItem = backButton
        //        guard let type = vm.settingType else { return }
        //        if type == .setting{
        //            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        //            navigationItem.rightBarButtonItem = saveButton
        //            okButton.isHidden = true
        //        }
        //navigationItem.title = profileSetType.rawValue
        navigationItem.title = vm.settingType?.navTitle
        successButton.isHidden = true
        resetButton.isHidden = true
        
        switch vm.settingType {
        case .onboarding:
            successButton.isHidden = false
        case .setting:
            resetButton.isHidden = false
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(startButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
        case .none:
            print("error")
        }
        
        
        line.backgroundColor = .cGray
        nicknameTextField.placeholder = PlaceholderEnum.nickName
        nicknameTextField.textColor = .cBlack
        nicknameTextField.contentMode = .left
        
        textLine.backgroundColor = .cGray
        
        
        nicknameFilterLabel.textAlignment = .left
        nicknameFilterLabel.numberOfLines = 1
        nicknameFilterLabel.font = .regular13
        
        mbtiLabel.text = "MBTI"
        mbtiLabel.font = .heavy20
        mbtiLabel.textColor = .cBlack
        
        
    }
    // MARK: - 버튼 함수 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func profileImageTapped() {
        let vc = SelectProfileViewController()
        vc.vm.outputProfileImage.value = vm.outputProfileImage.value
        vc.navTitle = vm.settingType?.navTitle
        vc.completion = { [weak self] image in
            guard let self else { return }
            self.vm.inputSetProfile.value = image
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func startButtonTapped() {
        vm.inputSaveUserData.value = self.nicknameTextField.text!
        
        if vm.settingType == .onboarding {
            nextView()
        }else{
            navigationController?.popViewController(animated: true)
        }
        
    }
    // MARK: - 리셋 버튼 나중에 램도 삭제해줘야됨!!!
    @objc func resetButtonTapped() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    // MARK: - 다음뷰로 이동하는 부분
    private func nextView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        //let navigationController = UINavigationController(rootViewController: TabBarController())
        
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    // MARK: - mbti 버튼 인덱스값 클로저로 받아오는 함수 부분
    private func mbtiCompletionSet() {
        mbtiEIButton.completion = { [weak self] index, button in
            guard let self else { return }
            self.vm.inputMBTIButton.value = (index,button)
        }
        mbtiSNButton.completion = { [weak self] index, button in
            guard let self else { return }
            self.vm.inputMBTIButton.value = (index,button)
        }
        mbtiTFButton.completion = { [weak self] index, button in
            guard let self else { return }
            self.vm.inputMBTIButton.value = (index,button)
        }
        mbtiJPButton.completion = { [weak self] index, button in
            guard let self else { return }
            self.vm.inputMBTIButton.value = (index,button)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //checkTextFiled()
        // TODO: 키보드에서 리턴키 눌렀을 때 확인하고 다음 화면으로 가는거 구현하기
        print(#function)
        return true
    }
    //텍스트 필드 글자 필터링 하는 부분
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.vm.inputNickname.value = textField.text
    }

}
