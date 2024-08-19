//
//  UserRepositoryCachesHandler.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/27.
//

import CoreData

final class UserRepositoryCachesHandler {}

extension UserRepositoryCachesHandler: UserRepositoryCaches {
    func fetchRecentUserListQuery(query: GetUserListParams, completion: @escaping (Result<[GUser], Error>) -> Void) {
        CoreDataStorage.shared.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = SUserEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(SUserEntity.createdAt),
                                                            ascending: true)]
                request.fetchLimit = query.perPage.unwrapped(or: 20)
                let result = try context.fetch(request).map { $0.toDomain() }

                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveRecentUserListQuery(users: [GUser], completion: @escaping (Result<[GUser], Error>) -> Void) {
        CoreDataStorage.shared.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                var users = users
                try self.cleanUpData(for: &users, inContext: context)
                let entities = users.compactMap({ SUserEntity(userInfo: $0, insertInto: context) })
                try context.save()

                completion(.success(entities.compactMap({ $0.toDomain() })))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}

// MARK: - Private
extension UserRepositoryCachesHandler {
    
    /// Clear data in storage before save new data
    /// - Parameters:
    ///   - users: the user list need to save, it will be updated after finish the func
    ///   - context: context of core data
    private func cleanUpData(
        for users: inout [GUser],
        inContext context: NSManagedObjectContext
    ) throws {
        let request: NSFetchRequest = SUserEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(SUserEntity.createdAt),
                                                    ascending: true)]
        var result = try context.fetch(request)
        
        removeDuplicates(for: &users, in: &result, inContext: context)
    }
    
    /// Remove storage item if it exist in new list that need to save,
    /// - Parameters:
    ///   - newList: the user list need to save, it will be updated createdAt after finish the func
    ///   - currentList: the user list has saved in storage, it will be removed the duplicate user after finish the func
    ///   - context: context of core data
    private func removeDuplicates(
        for newList: inout [GUser],
        in currentList: inout [SUserEntity],
        inContext context: NSManagedObjectContext
    ) {
        var duplicateList: [SUserEntity] = []
        var notDuplicateList: [SUserEntity] = []
        
        currentList.forEach { user in
            if let index = newList.firstIndex(where: { $0.username == user.login }) {
                duplicateList.append(user)
                newList[index].createdAt = user.createdAt
            } else {
                notDuplicateList.append(user)
            }
        }
        
        duplicateList.forEach { context.delete($0) }
        currentList = notDuplicateList
    }
}
