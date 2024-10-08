//
//  SwiftAsyncViewController.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/8.
//  Copyright © 2024 JL. All rights reserved.
//

import UIKit
import SnapKit

@objc(JLSwiftAsyncViewController)
class SwiftAsyncViewController: JLBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn1 = UIButton(type: .custom)
        btn1.backgroundColor = UIColor.orange
        btn1.setTitle("异步处理", for: .normal)
        btn1.addTarget(self, action: #selector(handleAsync(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn1)
        btn1.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.top.equalTo(self.view.snp.top).offset(10)
        }
    }

    override func title() -> String {
        return "Swift异步处理"
    }

}

extension SwiftAsyncViewController {

    @objc func handleAsync(sender: UIControl) {
        let obj = AvatarLoaderAsyncAwait()
        //Errors thrown from here are not handled
//        let c = try await obj.fetchAvatarURL(token: "")

        Task {
            // 如果抛出错误,则 a = nil
            let a = try? await obj.fetchAvatarURL(token: "a")
            print(a)
            // 如果抛出错误, 崩溃
//            let b = try! await obj.fetchAvatarURL(token: "")
//            print(b)

            do {
                let c = try await obj.fetchAvatarURL(token: "")
                print(c)
            }
            /* 可以不写
            catch let e as NSError {
                print("Parsing \(e)")
            }
             */
            catch {
                print("Other error: \(error)")
            }

            print("begin fetchAvatarURL")
            let c = try await obj.fetchAvatarURL(token: "")
            //由于上面代码产生错误  不会走到这里.但也不会崩溃
            print("end fetchAvatarURL")
            print(c)
        }


        //1.
//        Task {
//            do {
//                let ret = try await obj.loadAvatar(token: "")
//                print("Fetched result: \(ret).")
//            } catch {
//                print("Fetched err: \(error).")
//            }
//        }
        //2.
//        Task {
//            await obj.testAsynclet()
//        }

        //3
//        Task {
//            let v = await obj.fastestResponse()
//            print(v)
//        }
        // 4
//        let taskobj = TaskTest()
//        taskobj.main_func()


//        taskobj.main_func_detect()
    }
}

struct AvatarLoaderAsyncAwait {
    func loadAvatar(token: String) async throws -> UIImage {
        let url = try await fetchAvatarURL(token: token)
        let encryptedData = try await fetchAvatar(url: url)
        let decryptedData = try await decryptAvatar(data: encryptedData)
        return try await decodeImage(data: decryptedData)
    }

    func fetchAvatarURL(token: String) async throws -> String {
        // fetch url from net...
        if token.isEmpty {
            throw NSError(domain: "参数异常", code: 400)
        }
        return "avatarURL"
    }

    func fetchAvatar(url: String) async throws -> Data {
        // download avatar data...
        return Data()
    }

    func decryptAvatar(data: Data) async throws -> Data {
        // decrypt...
        return Data()
    }

    func decodeImage(data: Data) async throws -> UIImage {
        // decode...
        return UIImage(named: "1")!
    }
    //2
    func noAwaitAsynclet() async {
        print("begin noAwaitAsynclet")
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        Task.isCancelled ? print("noAwaitAsynclet is cancelled") : print("end noAwaitAsynclet")
    }

    func testAsynclet() async {
        let parentTask = Task {
            async let test = noAwaitAsynclet()
            await test
        }
        parentTask.cancel()
        await parentTask.value
        print("parentTask finished!")
    }
//3 Task group
    func requestFromServer1() async {
        print("begin requestFromServer1")
        // nanosecond : 十亿分之一秒
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        Task.isCancelled ? print("requestFromServer1 is cancelled") : print("end requestFromServer1")
    }

    func requestFromServer2() async {
        print("begin requestFromServer2")
        // nanosecond : 十亿分之一秒
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        Task.isCancelled ? print("requestFromServer2 is cancelled") : print("end requestFromServer2")
    }

    func fastestResponse() async -> Int {
        await withTaskGroup(of: Int.self, body: { group in
            group.addTask {
               let _ = await requestFromServer1()
               return 1
            }

            group.addTask {
               let _ = await requestFromServer2()
               return 2
            }

            return await group.next()!
        })

        print("fastestResponse")
        return 3
    }
}

final class TaskTest: Sendable {

    func my_func() async {
//        NSLog("before sleep")
//        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
//        NSLog("after sleep")
        NSLog("my_func")
    }

    func main_func() {
        NSLog("before main_func")
        Task {
            NSLog("before Task")
            await my_func()
            NSLog("after Task")
        }
        NSLog("after main_func")
    }

    func main_func_detect() {
        NSLog("before main_func")
        Task.detached { [self] in
            NSLog("before Task")
            await my_func()
            NSLog("after Task")
        }
        NSLog("after main_func")
    }
}

/* 很繁琐 不推荐*/
class AvatarLoader {
    func loadAvatar(token: String, completion: (UIImage?, Error?) -> Void) {
        fetchAvatarURL(token: token) { url, error  in
            guard let url = url else {
                // 在这个路径，经常容易漏掉执行 completion 或者 return 语句
                completion(nil, error)
                return
            }

            fetchAvatar(url: url) { data, error in
                guard let data = data else {
                    completion(nil, error)
                    return
                }
            }

            decryptAvatar(data: Data()) { data, error in
                guard let data = data else {
                    completion(nil, error)
                    return
                }
            }

            decodeImage(data: Data()) { image, error in
                completion(image, error)
            }
        }
    }

    func fetchAvatarURL(token: String, completion: (String?, Error?) -> Void) {
        // fetch url from net...
        completion(nil, nil)
    }

    func fetchAvatar(url: String, completion: (Data?, Error?) -> Void) {
        // download avatar data...
        completion(nil, nil)
    }

    func decryptAvatar(data: Data, completion: (Data?, Error?) -> Void) {
        // decrypt...
        completion(nil, nil)
    }

    func decodeImage(data: Data, completion: (UIImage?, Error?) -> Void) {
        // decode...
        completion(UIImage(named: ""), NSError(domain: "", code: 0))
    }
}


/* 很繁琐 不推荐*/
class AvatarLoaderResult {
    func loadAvatar(token: String, completion: (Result<UIImage, Error>) -> Void) {
        fetchAvatarURL(token: token) { result in
            switch result {
            case let .success(url):
                fetchAvatar(url: url) { result in
                    switch result {
                    case let .success(decryptData):
                        decryptAvatar(data: decryptData) { result in
                            switch result {
                            case let .success(avaratData):
                                decodeImage(data: avaratData) { result in
                                    completion(result)
                                }

                            case let .failure(error):
                                completion(.failure(error))
                            }
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchAvatarURL(token: String, completion: (Result<String, Error>) -> Void) {
        // fetch url from net...
        completion(.success("avatarURL"))
    }

    func fetchAvatar(url: String, completion: (Result<Data, Error>) -> Void) {
        // download avatar data...
        completion(.success(Data()))
    }

    func decryptAvatar(data: Data, completion: (Result<Data, Error>) -> Void) {
        // decrypt...
        completion(.success(Data()))
    }

    func decodeImage(data: Data, completion: (Result<UIImage, Error>) -> Void) {
        // decode...
        completion(.success(UIImage(named: "")!))
    }
}

