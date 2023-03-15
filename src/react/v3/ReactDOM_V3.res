/* First time reading a ReScript file? */
/* `external` is the foreign function call in OCaml. */
/* here we're saying `I guarantee that on the JS side, we have a `render` function in the module "react-dom"
 that takes in a reactElement, a dom element, and returns unit (nothing) */
/* It's like `let`, except you're pointing the implementation to the JS side. The compiler will inline these
 calls and add the appropriate `require("react-dom")` in the file calling this `render` */

// Helper so that ReactDOM itself doesn't bring any runtime
@val @return(nullable)
external querySelector: string => option<Dom.element> = "document.querySelector"

external domElementToObj: Dom.element => {..} = "%identity"

// TODO: Solid also allows objects as style. E.g. style={{"font-size": "1rem"}}
type style = ReactDOMStyle.t
type domRef
type classList

module Event = Solid_Event

module Props = {
  /* This list isn't exhaustive. We'll add more as we go. */
  /*
   * Watch out! There are two props types and the only difference is the type of ref.
   * Please keep in sync.
   */
  @deriving(abstract)
  type domProps = {
    @optional
    key: string,
    @optional
    ref: Js.nullable<Dom.element> => unit,
    /* accessibility */
    /* https://www.w3.org/TR/wai-aria-1.1/ */
    /* https://accessibilityresources.org/<aria-tag> is a great resource for these */
    /* [@optional] [@as "aria-current"] ariaCurrent: page|step|location|date|time|true|false, */
    @optional @as("aria-details")
    ariaDetails: string,
    @optional @as("aria-disabled")
    ariaDisabled: bool,
    @optional @as("aria-hidden")
    ariaHidden: bool,
    /* [@optional] [@as "aria-invalid"] ariaInvalid: grammar|false|spelling|true, */
    @optional @as("aria-keyshortcuts")
    ariaKeyshortcuts: string,
    @optional @as("aria-label")
    ariaLabel: string,
    @optional @as("aria-roledescription")
    ariaRoledescription: string,
    /* Widget Attributes */
    /* [@optional] [@as "aria-autocomplete"] ariaAutocomplete: inline|list|both|none, */
    /* [@optional] [@as "aria-checked"] ariaChecked: true|false|mixed, /* https://www.w3.org/TR/wai-aria-1.1/#valuetype_tristate */ */
    @optional @as("aria-expanded")
    ariaExpanded: bool,
    /* [@optional] [@as "aria-haspopup"] ariaHaspopup: false|true|menu|listbox|tree|grid|dialog, */
    @optional @as("aria-level")
    ariaLevel: int,
    @optional @as("aria-modal")
    ariaModal: bool,
    @optional @as("aria-multiline")
    ariaMultiline: bool,
    @optional @as("aria-multiselectable")
    ariaMultiselectable: bool,
    /* [@optional] [@as "aria-orientation"] ariaOrientation: horizontal|vertical|undefined, */
    @optional @as("aria-placeholder")
    ariaPlaceholder: string,
    /* [@optional] [@as "aria-pressed"] ariaPressed: true|false|mixed, /* https://www.w3.org/TR/wai-aria-1.1/#valuetype_tristate */ */
    @optional @as("aria-readonly")
    ariaReadonly: bool,
    @optional @as("aria-required")
    ariaRequired: bool,
    @optional @as("aria-selected")
    ariaSelected: bool,
    @optional @as("aria-sort")
    ariaSort: string,
    @optional @as("aria-valuemax")
    ariaValuemax: float,
    @optional @as("aria-valuemin")
    ariaValuemin: float,
    @optional @as("aria-valuenow")
    ariaValuenow: float,
    @optional @as("aria-valuetext")
    ariaValuetext: string,
    /* Live Region Attributes */
    @optional @as("aria-atomic")
    ariaAtomic: bool,
    @optional @as("aria-busy")
    ariaBusy: bool,
    /* [@optional] [@as "aria-live"] ariaLive: off|polite|assertive|rude, */
    @optional @as("aria-relevant")
    ariaRelevant: string,
    /* Drag-and-Drop Attributes */
    /* [@optional] [@as "aria-dropeffect"] ariaDropeffect: copy|move|link|execute|popup|none, */
    @optional @as("aria-grabbed")
    ariaGrabbed: bool,
    /* Relationship Attributes */
    @optional @as("aria-activedescendant")
    ariaActivedescendant: string,
    @optional @as("aria-colcount")
    ariaColcount: int,
    @optional @as("aria-colindex")
    ariaColindex: int,
    @optional @as("aria-colspan")
    ariaColspan: int,
    @optional @as("aria-controls")
    ariaControls: string,
    @optional @as("aria-describedby")
    ariaDescribedby: string,
    @optional @as("aria-errormessage")
    ariaErrormessage: string,
    @optional @as("aria-flowto")
    ariaFlowto: string,
    @optional @as("aria-labelledby")
    ariaLabelledby: string,
    @optional @as("aria-owns")
    ariaOwns: string,
    @optional @as("aria-posinset")
    ariaPosinset: int,
    @optional @as("aria-rowcount")
    ariaRowcount: int,
    @optional @as("aria-rowindex")
    ariaRowindex: int,
    @optional @as("aria-rowspan")
    ariaRowspan: int,
    @optional @as("aria-setsize")
    ariaSetsize: int,
    /* react textarea/input */
    @optional
    defaultChecked: bool,
    @optional
    defaultValue: string,
    /* global html attributes */
    @optional
    accessKey: string,
    @optional @deprecated
    className: string /* deprecated */,
    @optional
    class: string /* Solid also allows class */,
    @optional
    classList: classList /* Solid also allows class */,
    @optional
    contentEditable: bool,
    @optional
    contextMenu: string,
    @optional
    dir: string /* "ltr", "rtl" or "auto" */,
    @optional
    draggable: bool,
    @optional
    hidden: bool,
    @optional
    id: string,
    @optional
    lang: string,
    @optional
    role: string /* ARIA role */,
    @optional
    style: style,
    @optional
    spellCheck: bool,
    @optional
    tabIndex: int,
    @optional
    title: string,
    /* html5 microdata */
    @optional
    itemID: string,
    @optional
    itemProp: string,
    @optional
    itemRef: string,
    @optional
    itemScope: bool,
    @optional
    itemType: string /* uri */,
    /* tag-specific html attributes */
    @optional
    accept: string,
    @optional
    acceptCharset: string,
    @optional
    action: string /* uri */,
    @optional
    allowFullScreen: bool,
    @optional
    alt: string,
    @optional
    async: bool,
    @optional
    autoComplete: string /* has a fixed, but large-ish, set of possible values */,
    @optional
    autoCapitalize: string /* Mobile Safari specific */,
    @optional
    autoFocus: bool,
    @optional
    autoPlay: bool,
    @optional
    challenge: string,
    @optional
    charSet: string,
    @optional
    checked: bool,
    @optional
    cite: string /* uri */,
    @optional
    crossOrigin: string /* anonymous, use-credentials */,
    @optional
    cols: int,
    @optional
    colSpan: int,
    @optional
    content: string,
    @optional
    controls: bool,
    @optional
    coords: string /* set of values specifying the coordinates of a region */,
    @optional
    data: string /* uri */,
    @optional
    dateTime: string /* "valid date string with optional time" */,
    @optional
    default: bool,
    @optional
    defer: bool,
    @optional
    disabled: bool,
    @optional
    download: string /* should really be either a boolean, signifying presence, or a string */,
    @optional
    encType: string /* "application/x-www-form-urlencoded", "multipart/form-data" or "text/plain" */,
    @optional
    form: string,
    @optional
    formAction: string /* uri */,
    @optional
    formTarget: string /* "_blank", "_self", etc. */,
    @optional
    formMethod: string /* "post", "get", "put" */,
    @optional
    headers: string,
    @optional
    height: string /* in html5 this can only be a number, but in html4 it can ba a percentage as well */,
    @optional
    high: int,
    @optional
    href: string /* uri */,
    @optional
    hrefLang: string,
    @optional
    htmlFor: string /* substitute for "for" */,
    @optional
    httpEquiv: string /* has a fixed set of possible values */,
    @optional
    icon: string /* uri? */,
    @optional
    inputMode: string /* "verbatim", "latin", "numeric", etc. */,
    @optional
    integrity: string,
    @optional
    keyType: string,
    @optional
    kind: string /* has a fixed set of possible values */,
    @optional
    label: string,
    @optional
    list: string,
    @optional
    loading: [#"lazy" | #eager],
    @optional
    loop: bool,
    @optional
    low: int,
    @optional
    manifest: string /* uri */,
    @optional
    max: string /* should be int or Js.Date.t */,
    @optional
    maxLength: int,
    @optional
    media: string /* a valid media query */,
    @optional
    mediaGroup: string,
    @optional
    method: string /* "post" or "get" */,
    @optional
    min: string,
    @optional
    minLength: int,
    @optional
    multiple: bool,
    @optional
    muted: bool,
    @optional
    name: string,
    @optional
    nonce: string,
    @optional
    noValidate: bool,
    @optional @as("open")
    open_: bool /* use this one. Previous one is deprecated */,
    @optional
    optimum: int,
    @optional
    pattern: string /* valid Js RegExp */,
    @optional
    placeholder: string,
    @optional
    playsInline: bool,
    @optional
    poster: string /* uri */,
    @optional
    preload: string /* "none", "metadata" or "auto" (and "" as a synonym for "auto") */,
    @optional
    radioGroup: string,
    @optional
    readOnly: bool,
    @optional
    rel: string /* a space- or comma-separated (depending on the element) list of a fixed set of "link types" */,
    @optional
    required: bool,
    @optional
    reversed: bool,
    @optional
    rows: int,
    @optional
    rowSpan: int,
    @optional
    sandbox: string /* has a fixed set of possible values */,
    @optional
    scope: string /* has a fixed set of possible values */,
    @optional
    scoped: bool,
    @optional
    scrolling: string /* html4 only, "auto", "yes" or "no" */,
    /* seamless - supported by React, but removed from the html5 spec */
    @optional
    selected: bool,
    @optional
    shape: string,
    @optional
    size: int,
    @optional
    sizes: string,
    @optional
    span: int,
    @optional
    src: string /* uri */,
    @optional
    srcDoc: string,
    @optional
    srcLang: string,
    @optional
    srcSet: string,
    @optional
    start: int,
    @optional
    step: float,
    @optional
    summary: string /* deprecated */,
    @optional
    target: string,
    @optional @as("type")
    type_: string /* has a fixed but large-ish set of possible values */ /* use this one. Previous one is deprecated */,
    @optional
    useMap: string,
    @optional
    value: string,
    @optional
    width: string /* in html5 this can only be a number, but in html4 it can ba a percentage as well */,
    @optional
    wrap: string /* "hard" or "soft" */,
    /* Clipboard events */
    @optional
    onCopy: Event.t<ReactEvent.Clipboard.t>,
    @optional
    onCut: Event.t<ReactEvent.Clipboard.t>,
    @optional
    onPaste: Event.t<ReactEvent.Clipboard.t>,
    /* Composition events */
    @optional
    onCompositionEnd: Event.t<ReactEvent.Composition.t>,
    @optional
    onCompositionStart: Event.t<ReactEvent.Composition.t>,
    @optional
    onCompositionUpdate: Event.t<ReactEvent.Composition.t>,
    /* Keyboard events */
    @optional
    onKeyDown: Event.t<ReactEvent.Keyboard.t>,
    @optional
    onKeyPress: Event.t<ReactEvent.Keyboard.t>,
    @optional
    onKeyUp: Event.t<ReactEvent.Keyboard.t>,
    /* Focus events */
    @optional
    onFocus: Event.t<ReactEvent.Focus.t>,
    @optional
    onBlur: Event.t<ReactEvent.Focus.t>,
    /* Form events */
    @optional
    onChange: Event.t<ReactEvent.Form.t>,
    @optional
    onInput: Event.t<ReactEvent.Form.t>,
    @optional
    onSubmit: Event.t<ReactEvent.Form.t>,
    @optional
    onInvalid: Event.t<ReactEvent.Form.t>,
    /* Mouse events */
    @optional
    // onClick: Solid.Event.t<ReactEvent.Mouse.t>,
    onClick: Event.t<ReactEvent.Mouse.t>,
    @optional
    onContextMenu: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDoubleClick: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDrag: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragEnd: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragEnter: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragExit: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragLeave: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragOver: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragStart: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDrop: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseDown: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseEnter: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseLeave: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseMove: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseOut: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseOver: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseUp: Event.t<ReactEvent.Mouse.t>,
    /* Selection events */
    @optional
    onSelect: Event.t<ReactEvent.Selection.t>,
    /* Touch events */
    @optional
    onTouchCancel: Event.t<ReactEvent.Touch.t>,
    @optional
    onTouchEnd: Event.t<ReactEvent.Touch.t>,
    @optional
    onTouchMove: Event.t<ReactEvent.Touch.t>,
    @optional
    onTouchStart: Event.t<ReactEvent.Touch.t>,
    // Pointer events
    @optional
    onPointerOver: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerEnter: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerDown: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerMove: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerUp: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerCancel: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerOut: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerLeave: Event.t<ReactEvent.Pointer.t>,
    @optional
    onGotPointerCapture: Event.t<ReactEvent.Pointer.t>,
    @optional
    onLostPointerCapture: Event.t<ReactEvent.Pointer.t>,
    /* UI events */
    @optional
    onScroll: Event.t<ReactEvent.UI.t>,
    /* Wheel events */
    @optional
    onWheel: Event.t<ReactEvent.Wheel.t>,
    /* Media events */
    @optional
    onAbort: Event.t<ReactEvent.Media.t>,
    @optional
    onCanPlay: Event.t<ReactEvent.Media.t>,
    @optional
    onCanPlayThrough: Event.t<ReactEvent.Media.t>,
    @optional
    onDurationChange: Event.t<ReactEvent.Media.t>,
    @optional
    onEmptied: Event.t<ReactEvent.Media.t>,
    @optional
    onEncrypted: Event.t<ReactEvent.Media.t>,
    @optional
    onEnded: Event.t<ReactEvent.Media.t>,
    @optional
    onError: Event.t<ReactEvent.Media.t>,
    @optional
    onLoadedData: Event.t<ReactEvent.Media.t>,
    @optional
    onLoadedMetadata: Event.t<ReactEvent.Media.t>,
    @optional
    onLoadStart: Event.t<ReactEvent.Media.t>,
    @optional
    onPause: Event.t<ReactEvent.Media.t>,
    @optional
    onPlay: Event.t<ReactEvent.Media.t>,
    @optional
    onPlaying: Event.t<ReactEvent.Media.t>,
    @optional
    onProgress: Event.t<ReactEvent.Media.t>,
    @optional
    onRateChange: Event.t<ReactEvent.Media.t>,
    @optional
    onSeeked: Event.t<ReactEvent.Media.t>,
    @optional
    onSeeking: Event.t<ReactEvent.Media.t>,
    @optional
    onStalled: Event.t<ReactEvent.Media.t>,
    @optional
    onSuspend: Event.t<ReactEvent.Media.t>,
    @optional
    onTimeUpdate: Event.t<ReactEvent.Media.t>,
    @optional
    onVolumeChange: Event.t<ReactEvent.Media.t>,
    @optional
    onWaiting: Event.t<ReactEvent.Media.t>,
    /* Image events */
    @optional
    onLoad: Event.t<
      ReactEvent.Image.t,
    > /* duplicate */ /* ~onError: Event.t<ReactEvent.Image.t>=?, */,
    /* Animation events */
    @optional
    onAnimationStart: Event.t<ReactEvent.Animation.t>,
    @optional
    onAnimationEnd: Event.t<ReactEvent.Animation.t>,
    @optional
    onAnimationIteration: Event.t<ReactEvent.Animation.t>,
    /* Transition events */
    @optional
    onTransitionEnd: Event.t<ReactEvent.Transition.t>,
    /* svg */
    @optional
    accentHeight: string,
    @optional
    accumulate: string,
    @optional
    additive: string,
    @optional
    alignmentBaseline: string,
    @optional
    allowReorder: string,
    @optional
    alphabetic: string,
    @optional
    amplitude: string,
    @optional
    arabicForm: string,
    @optional
    ascent: string,
    @optional
    attributeName: string,
    @optional
    attributeType: string,
    @optional
    autoReverse: string,
    @optional
    azimuth: string,
    @optional
    baseFrequency: string,
    @optional
    baseProfile: string,
    @optional
    baselineShift: string,
    @optional
    bbox: string,
    @optional @as("begin")
    begin_: string /* use this one. Previous one is deprecated */,
    @optional
    bias: string,
    @optional
    by: string,
    @optional
    calcMode: string,
    @optional
    capHeight: string,
    @optional
    clip: string,
    @optional
    clipPath: string,
    @optional
    clipPathUnits: string,
    @optional
    clipRule: string,
    @optional
    colorInterpolation: string,
    @optional
    colorInterpolationFilters: string,
    @optional
    colorProfile: string,
    @optional
    colorRendering: string,
    @optional
    contentScriptType: string,
    @optional
    contentStyleType: string,
    @optional
    cursor: string,
    @optional
    cx: string,
    @optional
    cy: string,
    @optional
    d: string,
    @optional
    decelerate: string,
    @optional
    descent: string,
    @optional
    diffuseConstant: string,
    @optional
    direction: string,
    @optional
    display: string,
    @optional
    divisor: string,
    @optional
    dominantBaseline: string,
    @optional
    dur: string,
    @optional
    dx: string,
    @optional
    dy: string,
    @optional
    edgeMode: string,
    @optional
    elevation: string,
    @optional
    enableBackground: string,
    @optional @as("end")
    end_: string /* use this one. Previous one is deprecated */,
    @optional
    exponent: string,
    @optional
    externalResourcesRequired: string,
    @optional
    fill: string,
    @optional
    fillOpacity: string,
    @optional
    fillRule: string,
    @optional
    filter: string,
    @optional
    filterRes: string,
    @optional
    filterUnits: string,
    @optional
    floodColor: string,
    @optional
    floodOpacity: string,
    @optional
    focusable: string,
    @optional
    fontFamily: string,
    @optional
    fontSize: string,
    @optional
    fontSizeAdjust: string,
    @optional
    fontStretch: string,
    @optional
    fontStyle: string,
    @optional
    fontVariant: string,
    @optional
    fontWeight: string,
    @optional
    fomat: string,
    @optional
    from: string,
    @optional
    fx: string,
    @optional
    fy: string,
    @optional
    g1: string,
    @optional
    g2: string,
    @optional
    glyphName: string,
    @optional
    glyphOrientationHorizontal: string,
    @optional
    glyphOrientationVertical: string,
    @optional
    glyphRef: string,
    @optional
    gradientTransform: string,
    @optional
    gradientUnits: string,
    @optional
    hanging: string,
    @optional
    horizAdvX: string,
    @optional
    horizOriginX: string,
    @optional
    ideographic: string,
    @optional
    imageRendering: string,
    @optional @as("in")
    in_: string /* use this one. Previous one is deprecated */,
    @optional
    in2: string,
    @optional
    intercept: string,
    @optional
    k: string,
    @optional
    k1: string,
    @optional
    k2: string,
    @optional
    k3: string,
    @optional
    k4: string,
    @optional
    kernelMatrix: string,
    @optional
    kernelUnitLength: string,
    @optional
    kerning: string,
    @optional
    keyPoints: string,
    @optional
    keySplines: string,
    @optional
    keyTimes: string,
    @optional
    lengthAdjust: string,
    @optional
    letterSpacing: string,
    @optional
    lightingColor: string,
    @optional
    limitingConeAngle: string,
    @optional
    local: string,
    @optional
    markerEnd: string,
    @optional
    markerHeight: string,
    @optional
    markerMid: string,
    @optional
    markerStart: string,
    @optional
    markerUnits: string,
    @optional
    markerWidth: string,
    @optional
    mask: string,
    @optional
    maskContentUnits: string,
    @optional
    maskUnits: string,
    @optional
    mathematical: string,
    @optional
    mode: string,
    @optional
    numOctaves: string,
    @optional
    offset: string,
    @optional
    opacity: string,
    @optional
    operator: string,
    @optional
    order: string,
    @optional
    orient: string,
    @optional
    orientation: string,
    @optional
    origin: string,
    @optional
    overflow: string,
    @optional
    overflowX: string,
    @optional
    overflowY: string,
    @optional
    overlinePosition: string,
    @optional
    overlineThickness: string,
    @optional
    paintOrder: string,
    @optional
    panose1: string,
    @optional
    pathLength: string,
    @optional
    patternContentUnits: string,
    @optional
    patternTransform: string,
    @optional
    patternUnits: string,
    @optional
    pointerEvents: string,
    @optional
    points: string,
    @optional
    pointsAtX: string,
    @optional
    pointsAtY: string,
    @optional
    pointsAtZ: string,
    @optional
    preserveAlpha: string,
    @optional
    preserveAspectRatio: string,
    @optional
    primitiveUnits: string,
    @optional
    r: string,
    @optional
    radius: string,
    @optional
    refX: string,
    @optional
    refY: string,
    @optional
    renderingIntent: string,
    @optional
    repeatCount: string,
    @optional
    repeatDur: string,
    @optional
    requiredExtensions: string,
    @optional
    requiredFeatures: string,
    @optional
    restart: string,
    @optional
    result: string,
    @optional
    rotate: string,
    @optional
    rx: string,
    @optional
    ry: string,
    @optional
    scale: string,
    @optional
    seed: string,
    @optional
    shapeRendering: string,
    @optional
    slope: string,
    @optional
    spacing: string,
    @optional
    specularConstant: string,
    @optional
    specularExponent: string,
    @optional
    speed: string,
    @optional
    spreadMethod: string,
    @optional
    startOffset: string,
    @optional
    stdDeviation: string,
    @optional
    stemh: string,
    @optional
    stemv: string,
    @optional
    stitchTiles: string,
    @optional
    stopColor: string,
    @optional
    stopOpacity: string,
    @optional
    strikethroughPosition: string,
    @optional
    strikethroughThickness: string,
    @optional
    string: string,
    @optional
    stroke: string,
    @optional
    strokeDasharray: string,
    @optional
    strokeDashoffset: string,
    @optional
    strokeLinecap: string,
    @optional
    strokeLinejoin: string,
    @optional
    strokeMiterlimit: string,
    @optional
    strokeOpacity: string,
    @optional
    strokeWidth: string,
    @optional
    surfaceScale: string,
    @optional
    systemLanguage: string,
    @optional
    tableValues: string,
    @optional
    targetX: string,
    @optional
    targetY: string,
    @optional
    textAnchor: string,
    @optional
    textDecoration: string,
    @optional
    textLength: string,
    @optional
    textRendering: string,
    @optional @as("to")
    to_: string /* use this one. Previous one is deprecated */,
    @optional
    transform: string,
    @optional
    u1: string,
    @optional
    u2: string,
    @optional
    underlinePosition: string,
    @optional
    underlineThickness: string,
    @optional
    unicode: string,
    @optional
    unicodeBidi: string,
    @optional
    unicodeRange: string,
    @optional
    unitsPerEm: string,
    @optional
    vAlphabetic: string,
    @optional
    vHanging: string,
    @optional
    vIdeographic: string,
    @optional
    vMathematical: string,
    @optional
    values: string,
    @optional
    vectorEffect: string,
    @optional
    version: string,
    @optional
    vertAdvX: string,
    @optional
    vertAdvY: string,
    @optional
    vertOriginX: string,
    @optional
    vertOriginY: string,
    @optional
    viewBox: string,
    @optional
    viewTarget: string,
    @optional
    visibility: string,
    /* width::string? => */
    @optional
    widths: string,
    @optional
    wordSpacing: string,
    @optional
    writingMode: string,
    @optional
    x: string,
    @optional
    x1: string,
    @optional
    x2: string,
    @optional
    xChannelSelector: string,
    @optional
    xHeight: string,
    @optional
    xlinkActuate: string,
    @optional
    xlinkArcrole: string,
    @optional
    xlinkHref: string,
    @optional
    xlinkRole: string,
    @optional
    xlinkShow: string,
    @optional
    xlinkTitle: string,
    @optional
    xlinkType: string,
    @optional
    xmlns: string,
    @optional
    xmlnsXlink: string,
    @optional
    xmlBase: string,
    @optional
    xmlLang: string,
    @optional
    xmlSpace: string,
    @optional
    y: string,
    @optional
    y1: string,
    @optional
    y2: string,
    @optional
    yChannelSelector: string,
    @optional
    z: string,
    @optional
    zoomAndPan: string,
    /* RDFa */
    @optional
    about: string,
    @optional
    datatype: string,
    @optional
    inlist: string,
    @optional
    prefix: string,
    @optional
    property: string,
    @optional
    resource: string,
    @optional
    typeof: string,
    @optional
    vocab: string,
    /* react-specific */
    @optional
    dangerouslySetInnerHTML: {"__html": string},
    @optional
    suppressContentEditableWarning: bool,
  }

  /* This list isn't exhaustive. We'll add more as we go. */
  /*
   * Watch out! There are two props types and the only difference is the type of ref.
   * Please keep in sync.
   */
  @deriving(abstract)
  type props = {
    @optional
    key: string,
    @optional
    ref: Js.nullable<Dom.element> => unit,
    /* accessibility */
    /* https://www.w3.org/TR/wai-aria-1.1/ */
    /* https://accessibilityresources.org/<aria-tag> is a great resource for these */
    /* [@optional] [@as "aria-current"] ariaCurrent: page|step|location|date|time|true|false, */
    @optional @as("aria-details")
    ariaDetails: string,
    @optional @as("aria-disabled")
    ariaDisabled: bool,
    @optional @as("aria-hidden")
    ariaHidden: bool,
    /* [@optional] [@as "aria-invalid"] ariaInvalid: grammar|false|spelling|true, */
    @optional @as("aria-keyshortcuts")
    ariaKeyshortcuts: string,
    @optional @as("aria-label")
    ariaLabel: string,
    @optional @as("aria-roledescription")
    ariaRoledescription: string,
    /* Widget Attributes */
    /* [@optional] [@as "aria-autocomplete"] ariaAutocomplete: inline|list|both|none, */
    /* [@optional] [@as "aria-checked"] ariaChecked: true|false|mixed, /* https://www.w3.org/TR/wai-aria-1.1/#valuetype_tristate */ */
    @optional @as("aria-expanded")
    ariaExpanded: bool,
    /* [@optional] [@as "aria-haspopup"] ariaHaspopup: false|true|menu|listbox|tree|grid|dialog, */
    @optional @as("aria-level")
    ariaLevel: int,
    @optional @as("aria-modal")
    ariaModal: bool,
    @optional @as("aria-multiline")
    ariaMultiline: bool,
    @optional @as("aria-multiselectable")
    ariaMultiselectable: bool,
    /* [@optional] [@as "aria-orientation"] ariaOrientation: horizontal|vertical|undefined, */
    @optional @as("aria-placeholder")
    ariaPlaceholder: string,
    /* [@optional] [@as "aria-pressed"] ariaPressed: true|false|mixed, /* https://www.w3.org/TR/wai-aria-1.1/#valuetype_tristate */ */
    @optional @as("aria-readonly")
    ariaReadonly: bool,
    @optional @as("aria-required")
    ariaRequired: bool,
    @optional @as("aria-selected")
    ariaSelected: bool,
    @optional @as("aria-sort")
    ariaSort: string,
    @optional @as("aria-valuemax")
    ariaValuemax: float,
    @optional @as("aria-valuemin")
    ariaValuemin: float,
    @optional @as("aria-valuenow")
    ariaValuenow: float,
    @optional @as("aria-valuetext")
    ariaValuetext: string,
    /* Live Region Attributes */
    @optional @as("aria-atomic")
    ariaAtomic: bool,
    @optional @as("aria-busy")
    ariaBusy: bool,
    /* [@optional] [@as "aria-live"] ariaLive: off|polite|assertive|rude, */
    @optional @as("aria-relevant")
    ariaRelevant: string,
    /* Drag-and-Drop Attributes */
    /* [@optional] [@as "aria-dropeffect"] ariaDropeffect: copy|move|link|execute|popup|none, */
    @optional @as("aria-grabbed")
    ariaGrabbed: bool,
    /* Relationship Attributes */
    @optional @as("aria-activedescendant")
    ariaActivedescendant: string,
    @optional @as("aria-colcount")
    ariaColcount: int,
    @optional @as("aria-colindex")
    ariaColindex: int,
    @optional @as("aria-colspan")
    ariaColspan: int,
    @optional @as("aria-controls")
    ariaControls: string,
    @optional @as("aria-describedby")
    ariaDescribedby: string,
    @optional @as("aria-errormessage")
    ariaErrormessage: string,
    @optional @as("aria-flowto")
    ariaFlowto: string,
    @optional @as("aria-labelledby")
    ariaLabelledby: string,
    @optional @as("aria-owns")
    ariaOwns: string,
    @optional @as("aria-posinset")
    ariaPosinset: int,
    @optional @as("aria-rowcount")
    ariaRowcount: int,
    @optional @as("aria-rowindex")
    ariaRowindex: int,
    @optional @as("aria-rowspan")
    ariaRowspan: int,
    @optional @as("aria-setsize")
    ariaSetsize: int,
    /* react textarea/input */
    @optional
    defaultChecked: bool,
    @optional
    defaultValue: string,
    /* global html attributes */
    @optional
    accessKey: string,
    @optional @deprecated
    className: string /* deprecated */,
    @optional
    class: string /* Solid also allows class */,
    @optional
    classList: classList /* Solid also allows class */,
    @optional
    contentEditable: bool,
    @optional
    contextMenu: string,
    @optional
    dir: string /* "ltr", "rtl" or "auto" */,
    @optional
    draggable: bool,
    @optional
    hidden: bool,
    @optional
    id: string,
    @optional
    lang: string,
    @optional
    role: string /* ARIA role */,
    @optional
    style: style,
    @optional
    spellCheck: bool,
    @optional
    tabIndex: int,
    @optional
    title: string,
    /* html5 microdata */
    @optional
    itemID: string,
    @optional
    itemProp: string,
    @optional
    itemRef: string,
    @optional
    itemScope: bool,
    @optional
    itemType: string /* uri */,
    /* tag-specific html attributes */
    @optional
    accept: string,
    @optional
    acceptCharset: string,
    @optional
    action: string /* uri */,
    @optional
    allow: string,
    @optional
    allowFullScreen: bool,
    @optional
    alt: string,
    @optional
    async: bool,
    @optional
    autoComplete: string /* has a fixed, but large-ish, set of possible values */,
    @optional
    autoCapitalize: string /* Mobile Safari specific */,
    @optional
    autoFocus: bool,
    @optional
    autoPlay: bool,
    @optional
    challenge: string,
    @optional
    charSet: string,
    @optional
    checked: bool,
    @optional
    cite: string /* uri */,
    @optional
    crossorigin: bool,
    @optional
    cols: int,
    @optional
    colSpan: int,
    @optional
    content: string,
    @optional
    controls: bool,
    @optional
    coords: string /* set of values specifying the coordinates of a region */,
    @optional
    data: string /* uri */,
    @optional
    dateTime: string /* "valid date string with optional time" */,
    @optional
    default: bool,
    @optional
    defer: bool,
    @optional
    disabled: bool,
    @optional
    download: string /* should really be either a boolean, signifying presence, or a string */,
    @optional
    encType: string /* "application/x-www-form-urlencoded", "multipart/form-data" or "text/plain" */,
    @optional
    form: string,
    @optional
    formAction: string /* uri */,
    @optional
    formTarget: string /* "_blank", "_self", etc. */,
    @optional
    formMethod: string /* "post", "get", "put" */,
    @optional
    frameBorder: int /* deprecated, prefer to use css border instead */,
    @optional
    headers: string,
    @optional
    height: string /* in html5 this can only be a number, but in html4 it can ba a percentage as well */,
    @optional
    high: int,
    @optional
    href: string /* uri */,
    @optional
    hrefLang: string,
    @optional
    htmlFor: string /* substitute for "for" */,
    @optional
    httpEquiv: string /* has a fixed set of possible values */,
    @optional
    icon: string /* uri? */,
    @optional
    inputMode: string /* "verbatim", "latin", "numeric", etc. */,
    @optional
    integrity: string,
    @optional
    keyType: string,
    @optional
    kind: string /* has a fixed set of possible values */,
    @optional
    label: string,
    @optional
    list: string,
    @optional
    loop: bool,
    @optional
    low: int,
    @optional
    manifest: string /* uri */,
    @optional
    max: string /* should be int or Js.Date.t */,
    @optional
    maxLength: int,
    @optional
    media: string /* a valid media query */,
    @optional
    mediaGroup: string,
    @optional
    method: string /* "post" or "get" */,
    @optional
    min: string,
    @optional
    minLength: int,
    @optional
    multiple: bool,
    @optional
    muted: bool,
    @optional
    name: string,
    @optional
    nonce: string,
    @optional
    noValidate: bool,
    @optional @as("open")
    open_: bool /* use this one. Previous one is deprecated */,
    @optional
    optimum: int,
    @optional
    pattern: string /* valid Js RegExp */,
    @optional
    placeholder: string,
    @optional
    poster: string /* uri */,
    @optional
    preload: string /* "none", "metadata" or "auto" (and "" as a synonym for "auto") */,
    @optional
    radioGroup: string,
    @optional
    readOnly: bool,
    @optional
    rel: string /* a space- or comma-separated (depending on the element) list of a fixed set of "link types" */,
    @optional
    required: bool,
    @optional
    reversed: bool,
    @optional
    rows: int,
    @optional
    rowSpan: int,
    @optional
    sandbox: string /* has a fixed set of possible values */,
    @optional
    scope: string /* has a fixed set of possible values */,
    @optional
    scoped: bool,
    @optional
    scrolling: string /* html4 only, "auto", "yes" or "no" */,
    /* seamless - supported by React, but removed from the html5 spec */
    @optional
    selected: bool,
    @optional
    shape: string,
    @optional
    size: int,
    @optional
    sizes: string,
    @optional
    span: int,
    @optional
    src: string /* uri */,
    @optional
    srcDoc: string,
    @optional
    srcLang: string,
    @optional
    srcSet: string,
    @optional
    start: int,
    @optional
    step: float,
    @optional
    summary: string /* deprecated */,
    @optional
    target: string,
    @optional @as("type")
    type_: string /* has a fixed but large-ish set of possible values */ /* use this one. Previous one is deprecated */,
    @optional
    useMap: string,
    @optional
    value: string,
    @optional
    width: string /* in html5 this can only be a number, but in html4 it can ba a percentage as well */,
    @optional
    wrap: string /* "hard" or "soft" */,
    /* Clipboard events */
    @optional
    onCopy: Event.t<ReactEvent.Clipboard.t>,
    @optional
    onCut: Event.t<ReactEvent.Clipboard.t>,
    @optional
    onPaste: Event.t<ReactEvent.Clipboard.t>,
    /* Composition events */
    @optional
    onCompositionEnd: Event.t<ReactEvent.Composition.t>,
    @optional
    onCompositionStart: Event.t<ReactEvent.Composition.t>,
    @optional
    onCompositionUpdate: Event.t<ReactEvent.Composition.t>,
    /* Keyboard events */
    @optional
    onKeyDown: Event.t<ReactEvent.Keyboard.t>,
    @optional
    onKeyPress: Event.t<ReactEvent.Keyboard.t>,
    @optional
    onKeyUp: Event.t<ReactEvent.Keyboard.t>,
    /* Focus events */
    @optional
    onFocus: Event.t<ReactEvent.Focus.t>,
    @optional
    onBlur: Event.t<ReactEvent.Focus.t>,
    /* Form events */
    @optional
    onChange: Event.t<ReactEvent.Form.t>,
    @optional
    onInput: Event.t<ReactEvent.Form.t>,
    @optional
    onSubmit: Event.t<ReactEvent.Form.t>,
    @optional
    onInvalid: Event.t<ReactEvent.Form.t>,
    /* Mouse events */
    @optional
    onClick: Event.t<ReactEvent.Mouse.t>,
    // @optional
    // onClick: Solid.Event.t<ReactEvent.Mouse.t>,
    @optional
    onContextMenu: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDoubleClick: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDrag: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragEnd: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragEnter: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragExit: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragLeave: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragOver: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDragStart: Event.t<ReactEvent.Mouse.t>,
    @optional
    onDrop: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseDown: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseEnter: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseLeave: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseMove: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseOut: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseOver: Event.t<ReactEvent.Mouse.t>,
    @optional
    onMouseUp: Event.t<ReactEvent.Mouse.t>,
    /* Selection events */
    @optional
    onSelect: Event.t<ReactEvent.Selection.t>,
    /* Touch events */
    @optional
    onTouchCancel: Event.t<ReactEvent.Touch.t>,
    @optional
    onTouchEnd: Event.t<ReactEvent.Touch.t>,
    @optional
    onTouchMove: Event.t<ReactEvent.Touch.t>,
    @optional
    onTouchStart: Event.t<ReactEvent.Touch.t>,
    // Pointer events
    @optional
    onPointerOver: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerEnter: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerDown: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerMove: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerUp: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerCancel: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerOut: Event.t<ReactEvent.Pointer.t>,
    @optional
    onPointerLeave: Event.t<ReactEvent.Pointer.t>,
    @optional
    onGotPointerCapture: Event.t<ReactEvent.Pointer.t>,
    @optional
    onLostPointerCapture: Event.t<ReactEvent.Pointer.t>,
    /* UI events */
    @optional
    onScroll: Event.t<ReactEvent.UI.t>,
    /* Wheel events */
    @optional
    onWheel: Event.t<ReactEvent.Wheel.t>,
    /* Media events */
    @optional
    onAbort: Event.t<ReactEvent.Media.t>,
    @optional
    onCanPlay: Event.t<ReactEvent.Media.t>,
    @optional
    onCanPlayThrough: Event.t<ReactEvent.Media.t>,
    @optional
    onDurationChange: Event.t<ReactEvent.Media.t>,
    @optional
    onEmptied: Event.t<ReactEvent.Media.t>,
    @optional
    onEncrypted: Event.t<ReactEvent.Media.t>,
    @optional
    onEnded: Event.t<ReactEvent.Media.t>,
    @optional
    onError: Event.t<ReactEvent.Media.t>,
    @optional
    onLoadedData: Event.t<ReactEvent.Media.t>,
    @optional
    onLoadedMetadata: Event.t<ReactEvent.Media.t>,
    @optional
    onLoadStart: Event.t<ReactEvent.Media.t>,
    @optional
    onPause: Event.t<ReactEvent.Media.t>,
    @optional
    onPlay: Event.t<ReactEvent.Media.t>,
    @optional
    onPlaying: Event.t<ReactEvent.Media.t>,
    @optional
    onProgress: Event.t<ReactEvent.Media.t>,
    @optional
    onRateChange: Event.t<ReactEvent.Media.t>,
    @optional
    onSeeked: Event.t<ReactEvent.Media.t>,
    @optional
    onSeeking: Event.t<ReactEvent.Media.t>,
    @optional
    onStalled: Event.t<ReactEvent.Media.t>,
    @optional
    onSuspend: Event.t<ReactEvent.Media.t>,
    @optional
    onTimeUpdate: Event.t<ReactEvent.Media.t>,
    @optional
    onVolumeChange: Event.t<ReactEvent.Media.t>,
    @optional
    onWaiting: Event.t<ReactEvent.Media.t>,
    /* Image events */
    @optional
    onLoad: Event.t<
      ReactEvent.Image.t,
    > /* duplicate */ /* ~onError: Event.t<ReactEvent.Image.t>=?, */,
    /* Animation events */
    @optional
    onAnimationStart: Event.t<ReactEvent.Animation.t>,
    @optional
    onAnimationEnd: Event.t<ReactEvent.Animation.t>,
    @optional
    onAnimationIteration: Event.t<ReactEvent.Animation.t>,
    /* Transition events */
    @optional
    onTransitionEnd: Event.t<ReactEvent.Transition.t>,
    /* svg */
    @optional
    accentHeight: string,
    @optional
    accumulate: string,
    @optional
    additive: string,
    @optional
    alignmentBaseline: string,
    @optional
    allowReorder: string,
    @optional
    alphabetic: string,
    @optional
    amplitude: string,
    @optional
    arabicForm: string,
    @optional
    ascent: string,
    @optional
    attributeName: string,
    @optional
    attributeType: string,
    @optional
    autoReverse: string,
    @optional
    azimuth: string,
    @optional
    baseFrequency: string,
    @optional
    baseProfile: string,
    @optional
    baselineShift: string,
    @optional
    bbox: string,
    @optional @as("begin")
    begin_: string /* use this one. Previous one is deprecated */,
    @optional
    bias: string,
    @optional
    by: string,
    @optional
    calcMode: string,
    @optional
    capHeight: string,
    @optional
    clip: string,
    @optional
    clipPath: string,
    @optional
    clipPathUnits: string,
    @optional
    clipRule: string,
    @optional
    colorInterpolation: string,
    @optional
    colorInterpolationFilters: string,
    @optional
    colorProfile: string,
    @optional
    colorRendering: string,
    @optional
    contentScriptType: string,
    @optional
    contentStyleType: string,
    @optional
    cursor: string,
    @optional
    cx: string,
    @optional
    cy: string,
    @optional
    d: string,
    @optional
    decelerate: string,
    @optional
    descent: string,
    @optional
    diffuseConstant: string,
    @optional
    direction: string,
    @optional
    display: string,
    @optional
    divisor: string,
    @optional
    dominantBaseline: string,
    @optional
    dur: string,
    @optional
    dx: string,
    @optional
    dy: string,
    @optional
    edgeMode: string,
    @optional
    elevation: string,
    @optional
    enableBackground: string,
    @optional @as("end")
    end_: string /* use this one. Previous one is deprecated */,
    @optional
    exponent: string,
    @optional
    externalResourcesRequired: string,
    @optional
    fill: string,
    @optional
    fillOpacity: string,
    @optional
    fillRule: string,
    @optional
    filter: string,
    @optional
    filterRes: string,
    @optional
    filterUnits: string,
    @optional
    floodColor: string,
    @optional
    floodOpacity: string,
    @optional
    focusable: string,
    @optional
    fontFamily: string,
    @optional
    fontSize: string,
    @optional
    fontSizeAdjust: string,
    @optional
    fontStretch: string,
    @optional
    fontStyle: string,
    @optional
    fontVariant: string,
    @optional
    fontWeight: string,
    @optional
    fomat: string,
    @optional
    from: string,
    @optional
    fx: string,
    @optional
    fy: string,
    @optional
    g1: string,
    @optional
    g2: string,
    @optional
    glyphName: string,
    @optional
    glyphOrientationHorizontal: string,
    @optional
    glyphOrientationVertical: string,
    @optional
    glyphRef: string,
    @optional
    gradientTransform: string,
    @optional
    gradientUnits: string,
    @optional
    hanging: string,
    @optional
    horizAdvX: string,
    @optional
    horizOriginX: string,
    @optional
    ideographic: string,
    @optional
    imageRendering: string,
    @optional @as("in")
    in_: string /* use this one. Previous one is deprecated */,
    @optional
    in2: string,
    @optional
    intercept: string,
    @optional
    k: string,
    @optional
    k1: string,
    @optional
    k2: string,
    @optional
    k3: string,
    @optional
    k4: string,
    @optional
    kernelMatrix: string,
    @optional
    kernelUnitLength: string,
    @optional
    kerning: string,
    @optional
    keyPoints: string,
    @optional
    keySplines: string,
    @optional
    keyTimes: string,
    @optional
    lengthAdjust: string,
    @optional
    letterSpacing: string,
    @optional
    lightingColor: string,
    @optional
    limitingConeAngle: string,
    @optional
    local: string,
    @optional
    markerEnd: string,
    @optional
    markerHeight: string,
    @optional
    markerMid: string,
    @optional
    markerStart: string,
    @optional
    markerUnits: string,
    @optional
    markerWidth: string,
    @optional
    mask: string,
    @optional
    maskContentUnits: string,
    @optional
    maskUnits: string,
    @optional
    mathematical: string,
    @optional
    mode: string,
    @optional
    numOctaves: string,
    @optional
    offset: string,
    @optional
    opacity: string,
    @optional
    operator: string,
    @optional
    order: string,
    @optional
    orient: string,
    @optional
    orientation: string,
    @optional
    origin: string,
    @optional
    overflow: string,
    @optional
    overflowX: string,
    @optional
    overflowY: string,
    @optional
    overlinePosition: string,
    @optional
    overlineThickness: string,
    @optional
    paintOrder: string,
    @optional
    panose1: string,
    @optional
    pathLength: string,
    @optional
    patternContentUnits: string,
    @optional
    patternTransform: string,
    @optional
    patternUnits: string,
    @optional
    pointerEvents: string,
    @optional
    points: string,
    @optional
    pointsAtX: string,
    @optional
    pointsAtY: string,
    @optional
    pointsAtZ: string,
    @optional
    preserveAlpha: string,
    @optional
    preserveAspectRatio: string,
    @optional
    primitiveUnits: string,
    @optional
    r: string,
    @optional
    radius: string,
    @optional
    refX: string,
    @optional
    refY: string,
    @optional
    renderingIntent: string,
    @optional
    repeatCount: string,
    @optional
    repeatDur: string,
    @optional
    requiredExtensions: string,
    @optional
    requiredFeatures: string,
    @optional
    restart: string,
    @optional
    result: string,
    @optional
    rotate: string,
    @optional
    rx: string,
    @optional
    ry: string,
    @optional
    scale: string,
    @optional
    seed: string,
    @optional
    shapeRendering: string,
    @optional
    slope: string,
    @optional
    spacing: string,
    @optional
    specularConstant: string,
    @optional
    specularExponent: string,
    @optional
    speed: string,
    @optional
    spreadMethod: string,
    @optional
    startOffset: string,
    @optional
    stdDeviation: string,
    @optional
    stemh: string,
    @optional
    stemv: string,
    @optional
    stitchTiles: string,
    @optional
    stopColor: string,
    @optional
    stopOpacity: string,
    @optional
    strikethroughPosition: string,
    @optional
    strikethroughThickness: string,
    @optional
    string: string,
    @optional
    stroke: string,
    @optional
    strokeDasharray: string,
    @optional
    strokeDashoffset: string,
    @optional
    strokeLinecap: string,
    @optional
    strokeLinejoin: string,
    @optional
    strokeMiterlimit: string,
    @optional
    strokeOpacity: string,
    @optional
    strokeWidth: string,
    @optional
    surfaceScale: string,
    @optional
    systemLanguage: string,
    @optional
    tableValues: string,
    @optional
    targetX: string,
    @optional
    targetY: string,
    @optional
    textAnchor: string,
    @optional
    textDecoration: string,
    @optional
    textLength: string,
    @optional
    textRendering: string,
    @optional @as("to")
    to_: string /* use this one. Previous one is deprecated */,
    @optional
    transform: string,
    @optional
    u1: string,
    @optional
    u2: string,
    @optional
    underlinePosition: string,
    @optional
    underlineThickness: string,
    @optional
    unicode: string,
    @optional
    unicodeBidi: string,
    @optional
    unicodeRange: string,
    @optional
    unitsPerEm: string,
    @optional
    vAlphabetic: string,
    @optional
    vHanging: string,
    @optional
    vIdeographic: string,
    @optional
    vMathematical: string,
    @optional
    values: string,
    @optional
    vectorEffect: string,
    @optional
    version: string,
    @optional
    vertAdvX: string,
    @optional
    vertAdvY: string,
    @optional
    vertOriginX: string,
    @optional
    vertOriginY: string,
    @optional
    viewBox: string,
    @optional
    viewTarget: string,
    @optional
    visibility: string,
    /* width::string? => */
    @optional
    widths: string,
    @optional
    wordSpacing: string,
    @optional
    writingMode: string,
    @optional
    x: string,
    @optional
    x1: string,
    @optional
    x2: string,
    @optional
    xChannelSelector: string,
    @optional
    xHeight: string,
    @optional
    xlinkActuate: string,
    @optional
    xlinkArcrole: string,
    @optional
    xlinkHref: string,
    @optional
    xlinkRole: string,
    @optional
    xlinkShow: string,
    @optional
    xlinkTitle: string,
    @optional
    xlinkType: string,
    @optional
    xmlns: string,
    @optional
    xmlnsXlink: string,
    @optional
    xmlBase: string,
    @optional
    xmlLang: string,
    @optional
    xmlSpace: string,
    @optional
    y: string,
    @optional
    y1: string,
    @optional
    y2: string,
    @optional
    yChannelSelector: string,
    @optional
    z: string,
    @optional
    zoomAndPan: string,
    /* RDFa */
    @optional
    about: string,
    @optional
    datatype: string,
    @optional
    inlist: string,
    @optional
    prefix: string,
    @optional
    property: string,
    @optional
    resource: string,
    @optional
    typeof: string,
    @optional
    vocab: string,
    /* react-specific */
    @optional
    dangerouslySetInnerHTML: {"__html": string},
    @optional
    suppressContentEditableWarning: bool,
  }
}

include Props

// As we've removed `ReactDOMRe.createElement`, this enables patterns like
// React.createElement(ReactDOM.stringToComponent(multiline ? "textarea" : "input"), ...)
external stringToComponent: string => React.component<domProps> = "%identity"

module Style = ReactDOMStyle
