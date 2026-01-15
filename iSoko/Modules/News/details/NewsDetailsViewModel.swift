//
//  NewsDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class NewsDetailsViewModel: FormViewModel {

    private var state = State()

    override init() {
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            cells: [headerImage, headerTitle]
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: [bodyText]
        )
    }

    // MARK: - Lazy Rows
    private lazy var headerImage: FormRow = makeHeaderImageRow()
    private lazy var headerTitle: FormRow = makeHeaderTitleRow()
    private lazy var bodyText: FormRow = makeBodyTextRow()
    
    private func makeHeaderImageRow() -> FormRow {
        let imageRow = ImageFormRow(
            tag: 1,
            config: .init(
                image: UIImage(named: "logo"),
                height: 150,
                fillWidth: true,
                aspectRatio: 16 / 9
            )
        )
        
        return imageRow
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Welcome to the app, Welcome to the app, Welcome to the app",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
        
        return row
    }
    
    private func makeBodyTextRow() -> FormRow {
        RichDescriptionFormRow(
            tag: 3001,
            model: RichDescriptionModel(
                title: "Breaking News",
                htmlDescription: """
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>
<p>This is a simple paragraph of text. It demonstrates the basic use of the 'p' tag, which helps structure content into readable blocks. All text within the opening and closing tags will be treated as a single paragraph.</p>

""",
                textAlignment: .left
            )
        )
    }

    // MARK: - Header

    private func makeAssociationsHeaderFormRow() -> FormRow {
        AssociationHeaderFormRow(
            tag: 001001,
            model: AssociationHeaderModel(
                title: "Baraka Womens Football Club",
                subtitle: "Founded in 2025",
                desc: "12 Members",
                icon: .activate,
                cardBackgroundColor: .white,
                cardRadius: 0
            )
        )
    }

    // MARK: - State

    private struct State {
        var selectedSegmentIndex: Int = 0
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
    }
}
