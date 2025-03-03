this.wagon_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.wagon";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Une charrette pour transporter nos affaires, c\'est bien et tout, mais ça ne suffira pas. Économisons 15 000 couronnes et achetons-nous un vrai chariot !";
		this.m.RewardTooltip = "Vous débloquerez 27 emplacements supplémentaires dans votre inventaire.";
		this.m.UIText = "Avoir au moins 15 000 Couronnes";
		this.m.TooltipText = "Rassemblez la somme de 15 000 couronnes ou plus, afin de pouvoir vous permettre d\'acheter un chariot pour disposer d\'un espace d\'inventaire supplémentaire. Vous pouvez gagner de l\'argent en remplissant des contrats, en pillant des camps et des ruines, ou en faisant du commerce.";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]Un homme sage vous a dit un jour qu\'un chariot perd de sa valeur dès qu\'il quitte le terrain. Cet axiome vous trotte dans la tête alors que vous versez 10 000 couronnes pour le wagon. Mais ensuite, vous montez sur le siège du coffre, vous cognez votre botte contre la planche de bord et vous vous sentez comme chez vous. Vous vous retournez et jetez un coup d\'oeil dans le lit. Le constructeur du chariot y a installé une série de portes tournées sur le côté avec des pointes de fer situées pour accrocher des trophées, des peaux et d\'autres marchandises. Il y a aussi une cage pour contenir un chien ou un homme chien si besoin est. Une boîte à outils en bois avec un lourd clapet contient tous les outils nécessaires à la réparation des armes et des armures. Des essieux et des roues de rechange sont rangés sous le châssis.\n\nVous hochez la tête, vous faites demi-tour et jetez un coup d\'œil au cheval de trait. L\'animal de trait est une créature trapue aux jambes musclées et au comportement indifférent. Il ratisse sans réfléchir l\'herbe à ses pieds jusqu\'à ce que vous preniez la corde et le fassiez avancer. Le chariot roule, penche et vacille sans que rien ne suggère qu\'il a été conçu pour faire ce que vous lui avez demandé. Et pourtant, il est là.\n\n %randombrother% passe en sirotant une bouteille de vin. Quand il demande comment est le trajet, vous volez sa bouteille et la fracassez sur le côté du chariot et vous criez : \"C\'est du cuir brut !\".";
		this.m.SuccessButtonText = "Enfin.";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 4)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 15000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-10000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]10,000[/color] Couronnes"
		});
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Vous recevez 27 d\'emplacements d\'inventaire supplémentaires"
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

