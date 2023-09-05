import { render, screen } from "@testing-library/react";

import Layout from "./Layout";

const defaultProps: Props = {
  children: <div />,
  title: "Test",
};

// Call render. First pass the defaultProps to satisfy any required props, then
//  the overrides which are specific to the individual test
function doRender(overrides: Partial<Props> = {}) {
  render(<Layout {...defaultProps} {...overrides} />);
}

describe("Layout", () => {
  it("Header shows the application name", () => {
    const myComponent = doRender();
    const heading = screen.getByText(/DevOps Knowledge Share/i);

    expect(heading).toBeInTheDocument();
  });

  it("Header contains a link to the home page", () => {
    const myComponent = doRender();
    const link = screen
      .getByRole("img", { name: /dojo-small/i })
      .closest("a");

    expect(link).toHaveAttribute("href", "/");
  });
});
