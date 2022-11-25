import React from 'react';
import Breadcrump from '../../components/breadcrumb.js'
import { useHistory } from 'react-router-dom';
const RefundPolicy = (props) => {
    const history = useHistory();
    const currentCategory = history.location.pathname.split("/").pop().replaceAll('-',' ');
    return (
        <>
            <div className='refund-policy-section'>
                <Breadcrump currentPath={currentCategory} />
                <div className="refund-policy">
                    <p className="mainHeading">Refund Policy</p>
                    <p className="subHeading">When will my order be processed?</p>
                    <p className="paragraph">
                        All orders are handled and shipped out from our warehouse in NCR. Please allow extra time for your order to be processed during holidays and sale seasons., <br/><br/>We process orders between Monday and Saturday. Orders will be processed within 1-2 business days from the order date and shipped the next day after the processing day.
                    </p>
                    <p className="subHeading">How long will it take to receive my order?</p>
                    <p className="paragraph">
                        Once you place your order, please allow 1-2 business days to process your orders. After that, it will take 5-7 business days for delivery in the India , and 15-25 business days for international orders (depending on location). <br/><br/>Will I be charged with customs and taxes?<br/> The prices displayed on our site are Tax Included in INR, which means you you have paid the taxes once you receive your order.<br/><br/> Payment of these charges and taxes are your responsibility and will not be covered by us. We are not responsible for delays caused by the Courier Company. For further details of the charges, please Contact Us on support@contosotraders.com
                    </p>
                </div>
            </div>
            <hr/>
        </>
     );
}

export default RefundPolicy;