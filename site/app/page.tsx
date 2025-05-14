import MouseAura from "./MouseAura";

export default function Home() {
    return (
        <>
            <MouseAura />
            <div className="grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20 font-[family-name:var(--font-geist-sans)]">
                <main className="flex flex-col gap-[32px] row-start-2 items-center sm:items-start">
                    <div>
                        <h1 className="text-[32px] sm:text-[48px] font-bold text-center sm:text-left">
                            Welcome to <span className="text-[var(--geist-foreground)]">Znip</span> site!
                        </h1>
                        <p className="text-[16px] sm:text-[20px] text-center sm:text-left">
                            This is a simple site to showcase <span className="text-[var(--geist-foreground)]">Znip</span> tool
                        </p>
                        <p className="text-[16px] sm:text-[20px] text-center sm:text-left">
                            <span className="text-[var(--geist-foreground)]">Znip</span> is a tool to create and manage your own snippets
                            <br />
                            <span className="text-[var(--geist-foreground)]">Znip</span> is a tool to create and manage your own snippets
                            <br />
                            <span className="text-[var(--geist-foreground)]">Znip</span> is a tool to create and manage your own snippets
                            <br />
                            <span className="text-[var(--geist-foreground)]">Znip</span> is a tool to create and manage your own snippets
                        </p>
                    </div>
                </main>
                <footer className="row-start-3 flex gap-[24px] flex-wrap items-center justify-center">
                    <a
                        href="https://github.com/fulgidus/znip"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-[16px] sm:text-[20px] text-center sm:text-left text-[var(--geist-foreground)] hover:underline"
                    >
                        GitHub
                    </a>
                </footer>
            </div>
        </>
    );
}
