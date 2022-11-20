import React from 'react';
import { withRouter, Link, useHistory } from 'react-router-dom';
import { alpha, makeStyles } from '@material-ui/core/styles';
import {AppBar, InputAdornment, TextField} from '@material-ui/core';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import Badge from '@material-ui/core/Badge';
import MenuItem from '@material-ui/core/MenuItem';
import Menu from '@material-ui/core/Menu';
import AccountCircle from '@material-ui/icons/AccountCircle';
import MailIcon from '@material-ui/icons/Mail';
import NotificationsIcon from '@material-ui/icons/Notifications';
import MoreIcon from '@material-ui/icons/MoreVert';
import Logo from '../../assets/images/logo-horizontal.svg';
import SearchIconNew from '../../assets/images/original/Contoso_Assets/Icons/image_search_icon.svg'
// import WishlistIcon from '../../assets/images/original/Contoso_Assets/Icons/wishlist_icon.svg'
// import ProfileIcon from '../../assets/images/original/Contoso_Assets/Icons/profile_icon.svg'
// import BagIcon from '../../assets/images/original/Contoso_Assets/Icons/cart_icon.svg'
import UploadFile from '../uploadFile/uploadFile';
const useStyles = makeStyles((theme) => ({
  grow: {
    flexGrow: 1,
  },
  appbar : {
    backgroundColor:'red'
  },
  menuButton: {
    marginRight: theme.spacing(2),
  },
  title: {
    display: 'none',
    [theme.breakpoints.up('sm')]: {
      display: 'block',
    },
  },
  search: {
    position: 'relative',
    borderRadius: theme.shape.borderRadius,
    backgroundColor: alpha(theme.palette.common.white, 0.15),
    '&:hover': {
      backgroundColor: alpha(theme.palette.common.white, 0.25),
    },
    marginRight: theme.spacing(2),
    marginLeft: 50,
    width: '100%',
    [theme.breakpoints.up('sm')]: {
      marginLeft: 50,
      width: '50%',
      maxWidth: '650px',
      maxHeight: '48px'
    },
  },
  searchIcon: {
    padding: theme.spacing(0, 2),
    height: '100%',
    position: 'absolute',
    pointerEvents: 'none',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  inputRoot: {
    color: 'inherit',
  },
  inputInput: {
    padding: theme.spacing(1, 1, 1, 0),
    // vertical padding + font size from searchIcon
    paddingLeft: `calc(1em + ${theme.spacing(4)}px)`,
    transition: theme.transitions.create('width'),
    width: '100%',
    [theme.breakpoints.up('md')]: {
      width: '20ch',
    },
  },
  sectionDesktop: {
    display: 'none',
    [theme.breakpoints.up('md')]: {
      display: 'flex',
    },
  },
  sectionMobile: {
    display: 'flex',
    [theme.breakpoints.up('md')]: {
      display: 'none',
    },
  },
}));

function TopAppBar() {
  const classes = useStyles();
  const history = useHistory();
  const [anchorEl, setAnchorEl] = React.useState(null);
  const [mobileMoreAnchorEl, setMobileMoreAnchorEl] = React.useState(null);
  const [searchUpload, setSearchUpload] = React.useState(false)

  const isMenuOpen = Boolean(anchorEl);
  const isMobileMenuOpen = Boolean(mobileMoreAnchorEl);

  React.useEffect(() => {
    if(searchUpload === true){
      window.addEventListener('click', function(e){   
        if (!document.getElementById('searchbox').contains(e.target)){
          setSearchUpload(false)
        }
      });
    }
  }, [searchUpload]);

  React.useEffect(() => {
    setSearchUpload(false)
  }, [history.location.pathname]);

  const handleProfileMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMobileMenuClose = () => {
    setMobileMoreAnchorEl(null);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
    handleMobileMenuClose();
  };

  const handleMobileMenuOpen = (event) => {
    setMobileMoreAnchorEl(event.currentTarget);
  };

  const menuId = 'primary-search-account-menu';
  const renderMenu = (
    <Menu
      anchorEl={anchorEl}
      anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      id={menuId}
      keepMounted
      transformOrigin={{ vertical: 'top', horizontal: 'right' }}
      open={isMenuOpen}
      onClose={handleMenuClose}
    >
      <MenuItem onClick={handleMenuClose}>Profile</MenuItem>
      <MenuItem onClick={handleMenuClose}>My account</MenuItem>
    </Menu>
  );

  const mobileMenuId = 'primary-search-account-menu-mobile';
  const renderMobileMenu = (
    <Menu
      anchorEl={mobileMoreAnchorEl}
      anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      id={mobileMenuId}
      keepMounted
      transformOrigin={{ vertical: 'top', horizontal: 'right' }}
      open={isMobileMenuOpen}
      onClose={handleMobileMenuClose}
    >
      <MenuItem>
        <IconButton aria-label="show 4 new mails" color="inherit">
          <Badge badgeContent={4} color="secondary">
            <MailIcon />
          </Badge>
        </IconButton>
        <p>Messages</p>
      </MenuItem>
      <MenuItem>
        <IconButton aria-label="show 11 new notifications" color="inherit">
          <Badge badgeContent={11} color="secondary">
            <NotificationsIcon />
          </Badge>
        </IconButton>
        <p>Notifications</p>
      </MenuItem>
      <MenuItem onClick={handleProfileMenuOpen}>
        <IconButton
          aria-label="account of current user"
          aria-controls="primary-search-account-menu"
          aria-haspopup="true"
          color="inherit"
        >
          <AccountCircle />
        </IconButton>
        <p>Profile</p>
      </MenuItem>
    </Menu>
  );

  return (
    <div className={classes.grow}>
      <AppBar color='inherit' className='appbar box-shadow-0' position="static">
        <Toolbar className='p-0'>
          <div className='headerLogo'>
            <Link to="/">
                <img src={Logo} alt=""/>
            </Link>
          </div>
          <div className={`${classes.search} searchBar`} id="searchbox">
            <TextField
                // label="Search by product name or search by image"
                placeholder='Search by product name or search by image'
                variant="outlined"
                fullWidth
                InputProps={{
                    endAdornment: (
                    <InputAdornment>
                        <IconButton onClick={()=>setSearchUpload(!searchUpload)} className="searchBtn">
                          <img src={SearchIconNew} alt="iconimage"/>
                        </IconButton>
                    </InputAdornment>
                    )
                }}
            />
            {searchUpload?
            <div className='searchbar-upload'>
              Search by an image
              <UploadFile
                  title=""
                  subtitle="Drag an image or upload a file"
              />
            </div>
            :null}
          </div>
          <div className={classes.grow} />
          <div className={classes.sectionDesktop}>
            {/* <IconButton className='iconButton' aria-label="show 4 new mails" color="inherit">
              <Badge badgeContent={4} color="secondary">
                <img src={WishlistIcon} alt="iconimage"/>
              </Badge>
            </IconButton>
            <IconButton
              className='iconButton'
              edge="end"
              aria-label="account of current user"
              aria-controls={menuId}
              aria-haspopup="true"
              onClick={handleProfileMenuOpen}
              color="inherit"
            >
              <img src={ProfileIcon} alt="iconimage"/>
            </IconButton>
            <IconButton className='iconButton' aria-label="show 17 new notifications" color="inherit">
              <Badge badgeContent={17} color="secondary">
                <img src={BagIcon} alt="iconimage"/>
              </Badge>
            </IconButton> */}
          </div>
          <div className={classes.sectionMobile}>
            <IconButton
              aria-label="show more"
              aria-controls={mobileMenuId}
              aria-haspopup="true"
              onClick={handleMobileMenuOpen}
              color="inherit"
            >
              <MoreIcon />
            </IconButton>
          </div>
        </Toolbar>
      </AppBar>
      {renderMobileMenu}
      {renderMenu}
    </div>
  );
}
export default withRouter(TopAppBar);