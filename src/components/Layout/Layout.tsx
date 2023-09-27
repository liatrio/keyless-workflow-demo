import { ReactNode } from "react";
import Image from "next/image";
import Link from "next/link";

import globalStyles from "../../pages/index.module.scss";
import styles from "./Layout.module.scss";

type Props = {
  children: ReactNode;
  title?: string;
};

const Layout = ({ children }: Props) => (
  <>
    <header className={styles.navbar}>
      <nav title="home">
        <Link href="/">
          <a className={styles.navbarBrand}>
            <span className={globalStyles.logo}>
              <Image
                //src="/dojo-logo-sm.png"
                src="/wildcat.png"
                alt="dojo-small"
                width={50}
                height={50}
                objectPosition="absolute"
              />
            </span>
          </a>
        </Link>
        <span className={styles.navbarText}>DevOps Knowledge Share</span>
      </nav>
    </header>
    <div>{children}</div>
    <footer className={styles.footer}>
      Dojo Demo App Powered by{" "}
      <span className={globalStyles.logo}>
        <Image src="/liatrio.png" alt="Liatrio" width={96} height={53} />
      </span>
      <div>
        <Link href="/about">
          <a>About</a>
        </Link>
      </div>
    </footer>
  </>
);

export default Layout;
