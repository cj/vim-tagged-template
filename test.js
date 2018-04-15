function foo(bar) {
  console.log('baz');
}

`hello

${function foo(bar) {
  console.log('baz', html`<div></div>`);
}}
`

html`
<div></div>
${function foo(bar) {
  console.log('baz', html`<div>${css` body { background: red; } ${md`
# foo

`}`}}</div>`);
}}
<a href="foo">bar</a>
`;

md`
# yo

This is *awesome* [link](https://cool-dogs.technology)

${function foo(bar) {
  console.log('baz', html`<div></div>`);
}}
`


html`${directive(html`<div></div>`)}`
html`${directive(css`body { color: yellow; }`)}`
