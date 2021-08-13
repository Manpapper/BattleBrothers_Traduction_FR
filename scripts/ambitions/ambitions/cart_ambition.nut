this.cart_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.cart";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous pouvons à peine transporter plus d\'équipement ou de butin de guerre. Economisons 7 500 couronnes pour nous acheter un charette et soulager nos dos !";
		this.m.RewardTooltip = "Vous débloquerez 27 emplacements supplémentaires dans votre inventaire.";
		this.m.UIText = "Ayez au moins 7 500 couronnes";
		this.m.TooltipText = "Rassemblez un montant de 7 500 couronnes ou plus, afin de pouvoir vous permettre d\'acheter une charrette pour disposer d\'un espace d\'inventaire supplémentaire. Vous pouvez gagner de l\'argent en remplissant des contrats, en pillant des camps et des ruines, ou en faisant du commerce.";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]Rassembler suffisamment de couronnes pour payer le charpentier pour son travail vous a coûté un bras et une jambe, littéralement dans certains cas. Maintenant que vous êtes l\'heureux propriétaire d\'une nouvelle charrette, vous pouvez transporter à la fois plus d\'équipement et plus de butin de guerre, qu\'il s\'agisse d\'argenterie et de couronnes d\'or, ou des gambes à moitié déchirées et pleines de poux d\'un voyou quelconque.\n\nAprès avoir parcouru les premiers kilomètres avec les nouvelles roues, vous remarquez que %randombrother% semble avoir disparu. En regardant autour de vous, vous finissez par le trouver caché derrière quelques sacs de grains sur la charrette, ronflant paisiblement. Un coup d\'eau froide sur la tête et un coup de pied aux fesses remettent rapidement le paresseux sur pied et le font marcher comme les autres. Mais assurez-vous que les hommes connaissent leur place%SPEECH_ON%. Je ne veux rien de ça ! Le seul moyen pour que quelqu\'un de %companyname% se retrouve sur ce chariot est de porter sa propre tête sous le bras ! Soyez vigilants et tenez vos armes prêtes lorsque nous voyagerons sur ces terres!%SPEECH_OFF% Les hommes grognent et continuent.";
		this.m.SuccessButtonText = "Allons-y!";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 3 + this.Math.rand(0, 5);

		if (this.World.getTime().Days >= 25)
		{
			this.m.Score += 1;
		}

		if (this.World.getTime().Days >= 35)
		{
			this.m.Score += 1;
		}

		if (this.World.getTime().Days >= 45)
		{
			this.m.Score += 1;
		}
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 7500)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-5000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]5,000[/color] Couronnes"
		});
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Vous recevez 27 emplacements d\'inventaire supplémentaires"
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

