import H from "solid-js/h";

/**
 * Minimal wrapper around HyperScript in order to handle fragments correctly.
 * 
 * @param {*} elementNameOrFunc The name of the DOM element. E.g. div, li, input
 * @param {*} props The properties passed to the DOM element
 * @param  {...any} children The children of the DOM element
 * @returns A HyperScript function call
 */
export const createElement = function (elementNameOrFunc, props, ...children) {
  if (typeof elementNameOrFunc == 'function' && children.length == 0) {
    return elementNameOrFunc(props)
  }
  if (elementNameOrFunc === 'frgmnt' || (elementNameOrFunc.name && elementNameOrFunc.name === 'frgmnt')) {  // fragments are just arrays in HyperScript
    return children
  }
  return H(elementNameOrFunc, props, children)
}

/** Used to distinguish a fragment from other DOM elements */
export const Fragment = 'frgmnt';

/**
 * Creates a solid-js classList object.
 * 
 * @param  {...any} args An array of rescript tuples. E.g. [string, bool]
 * @returns An object with a property for each tuple
 */
export const makeClassList = (...args) => args.reduce((prev, curr) => {
  prev[curr[0]] = curr[1];
  return prev
}, {})