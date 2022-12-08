import React from "react"
import cn from 'classnames'

const Pagination = ({
  pageCount,
  pageIndex,
  className,
  btnClassName,
  pageTextClassName,
  urlForPage,
  goToPage
}) => {
	if (pageCount < 2) return "";
	
	const canPreviousPage = pageIndex > 0
	const canNextPage = pageIndex < pageCount - 1

	let btn_class = cn(
		"btn btn-xs px-2 ms-1",
		btnClassName || "btn-primary"
	);

  return (
    <div className={cn("text-xs text-white fw-bold", className)}>
      <a
        className={btn_class}
        href={urlForPage(1)}
        onClick={() => goToPage && goToPage(1)}
        disabled={!canPreviousPage}
      >
        <i className="fas fa-fw fa-angle-double-left"></i>
      </a>
      <a
        className={btn_class}
        href={urlForPage(pageIndex - 1)}
        onClick={() => goToPage && goToPage(pageIndex - 1)}
        disabled={!canPreviousPage}
      >
        <i className="fas fa-fw fa-angle-left"></i>
      </a>
      <span className={cn("px-3 text-sm", pageTextClassName)}>
        Page {pageIndex.toLocaleString("en-US")} of {pageCount.toLocaleString('en-US')}
      </span>
      <a
        className={btn_class}
        href={urlForPage(pageIndex + 1)}
        onClick={() => goToPage && goToPage(pageIndex + 1)}
        disabled={!canNextPage}
      >
        <i className="fas fa-fw fa-angle-right"></i>
      </a>
      <a
        className={btn_class}
        href={urlForPage(pageCount)}
        onClick={() => goToPage && goToPage(pageCount)}
        disabled={!canNextPage}
      >
        <i className="fas fa-fw fa-angle-double-right"></i>
      </a>
    </div>
  );
};

export default Pagination;