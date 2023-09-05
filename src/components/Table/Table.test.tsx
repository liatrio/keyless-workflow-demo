import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import Table, { Props } from "./Table";
import { Blog } from "../../pages/index.page";

const testBlogs: Blog[] = [
  {
    id: "0",
    title: "First Blog",
    firstName: "John Doe",
    link: "https://example.com",
    imageUrl:
      "https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png",
    datePosted: "2-22-22",
  },
  {
    id: "1",
    title: "Second Blog",
    firstName: "John Doe",
    link: "https://example.com",
    imageUrl:
      "https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png",
    datePosted: "2-22-22",
  },
  {
    id: "2",
    title: "Third Blog",
    firstName: "John Doe",
    link: "https://example.com",
    imageUrl:
      "https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png",
    datePosted: "2-22-22",
  },
];

function doRender(overrides: Partial<Props> = {}) {
  render(
    <Table
      enableImageURL={true}
      blogList={testBlogs}
      handleDelete={() => {}}
      {...overrides}
    />
  );
}

describe("Table", () => {
  it("Table renders one table component", () => {
    doRender();
    const table = screen.getByRole("table");

    expect(table).toBeInTheDocument();
  });

  it("Table renders three rows", () => {
    doRender();
    const rows = screen.getAllByRole("row");

    expect(rows).toHaveLength(4);
  });

  it("Table renders six columns", () => {
    doRender();
    const cols = screen.getAllByRole("columnheader");

    expect(cols).toHaveLength(6);
  });

  it("Table renders images in column", () => {
    doRender();
    const images = screen.getAllByRole("img");

    expect(images).toHaveLength(3);
  });

  it("Table renders a delete button for each row with content", () => {
    doRender();
    const button = screen.getAllByText(/x/i, { selector: "button" });

    expect(button).toHaveLength(3);
  });

  it("Table removes entry when delete button is clicked", () => {
    const deleteHandler = jest.fn();

    doRender({ handleDelete: deleteHandler });
    const initialButtons = screen.getAllByText(/x/i, { selector: "button" });

    userEvent.click(initialButtons[0]);

    expect(deleteHandler).toHaveBeenCalled();
  });
});
