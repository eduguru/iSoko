🧰 ImageFormRow Usage Examples
✅ 1. Centered Image with Default Styling
let row = ImageFormRow(
    tag: 1,
    config: .init(
        image: UIImage(named: "logo"),
        height: 100
    )
)
// → Image centered with 16pt side padding, no background, no rounding.

✅ 2. Full-Width Image (e.g., Banner)
let row = ImageFormRow(
    tag: 2,
    config: .init(
        image: UIImage(named: "banner"),
        height: 180,
        fillWidth: true
    )
)
// → Image stretches across full width of the cell.

✅ 3. Rounded Icon with Background
let row = ImageFormRow(
    tag: 3,
    config: .init(
        image: UIImage(named: "avatar"),
        height: 100,
        backgroundColor: .systemGray6,
        cornerRadius: 50 // Fully rounded if width ≈ height
    )
)
// → Use for profile/avatar images with soft background and circle crop.

✅ 4. Image with Aspect Ratio (16:9)
let row = ImageFormRow(
    tag: 4,
    config: .init(
        image: UIImage(named: "video_preview"),
        height: 180,
        fillWidth: true,
        aspectRatio: 16 / 9
    )
)
// → Perfect for embedded videos or wide content previews.

✅ 5. Square Image with Slight Rounding
let row = ImageFormRow(
    tag: 5,
    config: .init(
        image: UIImage(named: "qr_code"),
        height: 150,
        cornerRadius: 12
    )
)
// → Centered square image with slightly rounded corners.

✅ 6. Transparent Background, Slightly Smaller Image
let row = ImageFormRow(
    tag: 6,
    config: .init(
        image: UIImage(named: "signature"),
        height: 80,
        fillWidth: false
    )
)
// → Good for lighter images like signatures or small logos.

