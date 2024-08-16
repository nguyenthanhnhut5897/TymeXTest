//
//  BaseViewModel.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/27.
//

import Foundation

protocol BasePresentable {
    var identifier: String { get set }
    var height: CGFloat { get set }
    var estimateHeight: CGFloat { get set }
    var section: Int { get set }
}

protocol BaseCellPresentable: BasePresentable {
    var row: Int { get set }
}

protocol BaseCellConfigurable {
    func setup(viewModel: BaseCellPresentable)
}

protocol BaseSectionPresentable: BasePresentable {}

protocol BaseSectionConfigurable {
    func setup(viewModel: BaseSectionPresentable)
}

class BaseViewModel {
    var page: Int = 1
    var limit: Int = 20
    var loadMore: Bool = true
    var isLoading: Bool = false
    
    var viewModels = [BasePresentable]()
    
    /// Number of sections
    var numberSections: Int {
        let sectionModels = viewModels.compactMap({ $0 as? BaseSectionPresentable }).map({ $0.section })
        let sectionMax = sectionModels.max() ?? -1
        let cellModels = viewModels.compactMap({ $0 as? BaseCellPresentable }).map({ $0.section })
        let sectionRowMax = cellModels.max() ?? -1
        return max(sectionMax, sectionRowMax) + 1
    }
    
    /// Number rows of section
    /// - Parameter section: section index
    /// - Returns: total row
    func numberRowOfSections(_ section: Int = 0) -> Int {
        let cellRows = viewModels.compactMap({ $0 as? BaseCellPresentable })
                              .filter({ $0.section == section })
                              .map({ $0.row })
        
        return (cellRows.max() ?? -1) + 1
    }
    
    /// Last section index
    var lastSectionIndex: Int {
        return numberSections == 0 ? 0 : (numberSections - 1)
    }
    
    func sectionHeight(at section: Int) -> CGFloat {
        return sectionModel(at: section)?.height ?? 0
    }
    
    func sectionEstimateHeight(at section: Int) -> CGFloat {
        return sectionModel(at: section)?.estimateHeight ?? 0
    }
    
    func cellHeight(at indexPath: IndexPath) -> CGFloat {
        return cellModel(at: indexPath)?.height ?? 0
    }
    
    func cellEstimateHeight(at indexPath: IndexPath) -> CGFloat {
        return cellModel(at: indexPath)?.estimateHeight ?? 0
    }
    
    /// Find a data model for cell
    /// - Parameter indexPath: position of cell
    /// - Returns: data model
    func cellModel(at indexPath: IndexPath) -> BaseCellPresentable? {
        let cellModels = viewModels.compactMap({ $0 as? BaseCellPresentable })
        return cellModels.first(where: { $0.section == indexPath.section && $0.row == indexPath.row })
    }
    
    /// Find a data model for section
    /// - Parameter section: position of section
    /// - Returns: data model
    func sectionModel(at section: Int) -> BaseSectionPresentable? {
        let sectionModels = viewModels.compactMap({ $0 as? BaseSectionPresentable })
        return sectionModels.first(where: { $0.section == section })
    }
}
