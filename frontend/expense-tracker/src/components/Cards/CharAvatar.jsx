import React  from "react";
import { getInitials } from "../../utils/helper";

const CharAvatar = ({full_name, width, height, style}) => {
    return <div className={`${width || "w-12"} ${height || "h-12"} ${style || ""} flex item-center justify-center rounded-full text-gray-900 font-medium bg-gray-100`}>
        {getInitials(full_name || "")}
    </div>;
}

export default CharAvatar;