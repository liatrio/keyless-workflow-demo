import {
  render,
  screen,
  getAllByTestId,
  getByRole,
  getAllByRole,
  waitFor,
} from "@testing-library/react";
import Home, { Blog, Props, getServerSideProps } from "./index.page";
import userEvent from "@testing-library/user-event";
import { createMocks } from "node-mocks-http";

const { res } = createMocks();
const sampleData: Blog[] = [
  {
    id: "0",
    title: "First Blog",
    firstName: "John Doe",
    link: "https://example.com",
    datePosted: "2-22-22",
  },
];

function doRender(overrides: Partial<Props> = {}) {
  render(<Home initalBlogList={sampleData} {...overrides} />);
}

describe("Home", () => {
  beforeEach(() => {
    global.fetch = jest.fn().mockImplementation(() => Promise.resolve(res));
  });

  afterEach(() => {
    jest.mocked(global.fetch).mockClear();
    delete global.fetch;
  });

  it("renders the mainBanner", async () => {
    doRender();

    const header = screen.getByRole("heading");

    expect(header).toBeInTheDocument();
  });

  it("allows users to submit new forms", async () => {
    const testInputs = ["Author", "My Title", "https://example.com"];
    res.json = jest.fn().mockReturnValue({
      firstName: testInputs[0],
      title: testInputs[1],
      link: testInputs[2],
      datePosted: "2-22-22",
    });

    doRender();

    const shareForm = screen.getByTestId("shareForm");
    const inputFields = getAllByTestId(shareForm, /input/);

    inputFields.forEach((input, index) => {
      userEvent.type(input, testInputs[index]);
    });

    const submitButton = getByRole(shareForm, "button");
    await waitFor(() => userEvent.click(submitButton));

    const table = screen.getByRole("table");
    const rows = getAllByRole(table, "row");

    expect(rows).toHaveLength(3);
  });

  it("allows users to delete blog entries", () => {
    res.json = jest.fn();

    doRender();

    const table = screen.getByRole("table");
    const rows = getAllByRole(table, "row");
    const deleteButton = getByRole(rows[1], "button");

    userEvent.click(deleteButton);

    const rowsAfterDelete = getAllByRole(table, "row");

    expect(rowsAfterDelete).toHaveLength(1);
  });

  it("getServerSideProps returns expected data.", async () => {
    res.json = jest.fn().mockReturnValue(sampleData);

    const result = await getServerSideProps(res);
    expect(result).toEqual({
      props: { initalBlogList: sampleData, enableImageURL: false },
    });
  });
});
