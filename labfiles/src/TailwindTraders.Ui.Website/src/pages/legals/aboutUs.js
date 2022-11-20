import React from 'react';
import Breadcrump from '../../components/breadcrumb.js'
import { useHistory } from 'react-router-dom';
const AboutUs = (props) => {
    const history = useHistory();
    const currentCategory = history.location.pathname.split("/").pop().replaceAll('-',' ');
    return (
        <>
            <div className='refund-policy-section'>
                <Breadcrump currentPath={currentCategory} />
                <div className="refund-policy">
                    <p className="mainHeading">About Us</p>
                    <p className="subHeading">Our Mission</p>
                    <p className="paragraph">
                        To demonstrate passion by delivering quality products and spread the WOW factor among our customers. We aspire to be a brand that caters to youth and accessories their lifestyle with funky and colorful accessories.
                    </p>
                    <p className="subHeading">Who Are We?</p>
                    <p className="paragraph">
                        We are not just another brand into e-commerce; unlocktrends is a brand synonymous with youth style quotient. What sets us apart is that, we have a young hearted team with an ardor to excel. The crux of our company is that it is made up of a team of creative professionals. The company is led by accomplished management with extensive e-commerce and related industries experience. The company follows a performance driven work culture full of freedom and fun. Apart from an exciting business to complement people’s lifestyle, the company re-in forces these ethos through a work environment with amenities that keep the workplace full of fun and passion.
                    </p>
                    <p className="subHeading">Who Are We Looking For?</p>
                    <p className="paragraph">
                        Anyone who can think creatively and innovatively, we are NOT looking for people who can only work protocol on the internet. Absolutely not believe in ‘chalta hai’, come with a do-or-die attitude. Willing to put in immense endeavor in keeping unlocktrends in its rightful place at the top of the pile. Have very high standards for themselves and work enthusiastically to achieve them. Persevere and persist in problem solving and don’t have the word “quit” in their dictionary Are passionate and driven by purpose to achieve great things in life Are intelligent yet humble, and know how to be a team player. Are fun to hang out with, both at a party as well as at a midnight hack-a-thon Don’t have all the answers, but sure know how to find them Consider going the extra mile, a norm
                    </p>
                    <p className="subHeading">Who Are We Looking For?</p>
                    <p className="paragraph">
                        Anyone who can think creatively and innovatively, we are NOT looking for people who can only work protocol on the internet. Absolutely not believe in ‘chalta hai’, come with a do-or-die attitude. Willing to put in immense endeavor in keeping unlocktrends in its rightful place at the top of the pile. Have very high standards for themselves and work enthusiastically to achieve them. Persevere and persist in problem solving and don’t have the word “quit” in their dictionary Are passionate and driven by purpose to achieve great things in life Are intelligent yet humble, and know how to be a team player. Are fun to hang out with, both at a party as well as at a midnight hack-a-thon Don’t have all the answers, but sure know how to find them Consider going the extra mile, a norm
                    </p>
                    <p className="subHeading">Why Should You Work With Us?</p>
                    <p className="paragraph">
                        One Team- We work as one team that wants to achieve more and learn more. Focused- We stay focused and have Out-of the Box- Thinking. Try to give our best by pushing ourselves to our limits. Accessible-We believe in staying connected and welcome new ideas, thoughts, feedbacks, questions. Grow Ahead- We believe in long term returns, no matter how much we have achieved, there is still more to learn and grow. Think ahead, there are no shortcuts.
                    </p>
                </div>
            </div>
            <hr/>
        </>
     );
}

export default AboutUs;