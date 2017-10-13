<?php
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
die;
}
$data = file_get_contents("php://input");
preg_match("/\<EMailAddress\>(.*?)\<\/EMailAddress\>/", $data, $matches);
header("Content-Type: application/xml");
?>
<?php echo '<'.'?xml version="1.0" encoding="utf-8" ?'.'>'; ?>
<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">
<Response xmlns="http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a">
<Account>
<AccountType>email</AccountType>
<Action>settings</Action>
<Protocol>
<Type>IMAP</Type>
<Server>imap.thorbis.com</Server>
<Port>993</Port>
<DomainRequired>off</DomainRequired>
<LoginName><?php echo $matches[1]; ?></LoginName>
<SPA>off</SPA>
<SSL>on</SSL>
<AuthRequired>on</AuthRequired>
</Protocol>
<Protocol>
<Type>POP3</Type>
<Server>pop3.thorbis.com</Server>
<Port>995</Port>
<LoginName><?php echo $matches[1]; ?></LoginName>
<DomainRequired>off</DomainRequired>
<SPA>off</SPA>
<SSL>on</SSL>
<AuthRequired>on</AuthRequired>
</Protocol>
<Protocol>
<Type>SMTP</Type>
<Server>smtp.thorbis.com</Server>
<Port>465</Port>
<DomainRequired>off</DomainRequired>
<LoginName><?php echo $matches[1]; ?></LoginName>
<SPA>off</SPA>
<SSL>on</SSL>
<AuthRequired>on</AuthRequired>
<UsePOPAuth>on</UsePOPAuth>
<SMTPLast>on</SMTPLast>
</Protocol>
</Account>
</Response>
</Autodiscover>
