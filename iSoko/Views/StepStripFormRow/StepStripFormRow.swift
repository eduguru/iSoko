//
//  StepStripFormRow.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

public final class StepStripFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier = String(describing: StepStripCell.self)
    public var cellClass: AnyClass? { StepStripCell.self }

    public var model: StepStripModel

    public init(tag: Int, model: StepStripModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? StepStripCell else { return cell }
        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
