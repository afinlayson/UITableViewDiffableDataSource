import UIKit

protocol WithTitle: Hashable {
    var title: String { get }
}

class CustomDiff<A: WithTitle, B: Hashable>: UITableViewDiffableDataSource<A, B> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let snapShot = self.snapshot()
        let section = snapShot.sectionIdentifiers[section]
        return section.title
    }
    
    override func snapshot() -> NSDiffableDataSourceSnapshot<A, B> {
        return super.snapshot()
    }
}


