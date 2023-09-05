import React from "react";
import { Blog } from "../../pages/index.page";
import styles from "./Table.module.scss";

export interface Props {
  blogList: Blog[];
  handleDelete: any;
  enableImageURL: boolean;
}

const Table: React.FC<Props> = ({ blogList, handleDelete, enableImageURL }) => {
  const columnLabels: string[] = [
    "Title",
    "Contributor",
    "Link",
    ...(enableImageURL ? ["Image"] : []),
    "Posted",
    "",
  ];

  return (
    <table className={styles.table}>
      <thead className={styles.tableheader}>
        <tr className={styles.headerRow}>
          {columnLabels.map((val, key) => {
            return <th key={key}>{val}</th>;
          })}
        </tr>
      </thead>
      <tbody>
        {blogList.map((blog, key) => {
          return (
            <tr className={styles.row} key={key}>
              <td>{blog.title}</td>
              <td>{blog.firstName}</td>
              <td>
                <a
                  className={styles.link}
                  rel="noreferrer noopener"
                  target="_blank"
                  href={blog.link.toString()}
                >
                  {new URL(blog.link).hostname}
                </a>
              </td>
              {enableImageURL && (
                <td>
                  <img
                    alt="blogimage"
                    src={blog.imageUrl?.toString()}
                    className={styles.image}
                  />
                </td>
              )}
              <td>
                {new Date(blog.datePosted!).toLocaleString("en-US", {
                  timeZone: "America/Chicago",
                })}
              </td>
              <td>
                <button
                  className={styles.button}
                  onClick={async () => {
                    handleDelete(blog.id);
                  }}
                >
                  x
                </button>
              </td>
            </tr>
          );
        })}
      </tbody>
    </table>
  );
};

export default Table;
