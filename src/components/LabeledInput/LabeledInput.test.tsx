import { render, screen, getAllByTestId } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import LabeledInput, { Props } from "./LabeledInput";

function doRender(overrides: Partial<Props> = {}) {
  render(<LabeledInput label="Contributor" name="firstName" {...overrides} />);
}

describe("LabeledInput", () => {
  it("renders input fields", () => {
    doRender();

    const inputFields = screen.getAllByTestId(/input/);

    expect(inputFields).toHaveLength(1);
  });

  it("state is updated on change", () => {
    doRender();

    const inputField = screen.getByTestId(/input/);

    userEvent.type(inputField, "test");

    expect(inputField).toHaveValue("test");
  });
});
