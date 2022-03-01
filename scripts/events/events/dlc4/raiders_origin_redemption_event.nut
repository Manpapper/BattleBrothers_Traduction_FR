this.raiders_origin_redemption_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.raiders_origin_redemption_";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{%monk% est un moine qui, à ce moment, est très, très loin de chez lui. Les jours passés sur la route sont déjà assez difficiles, et les jours de repos, remplis de violence et de pillage, le sont encore plus. Il n'est pas surprenant qu'il soit venu vous voir avec une offre. Bien qu'il soit dans votre compagnie depuis un certain temps, il est clair qu'il est toujours un homme de la civilisation.\n\nIl explique une vieille loi : en tant que pillard, vous êtes persona non grata, mais en tant que pillard avec beaucoup d'argent, il y a une chance que vous puissiez racheter le droit de traiter avec les nobles de ce pays. Le moine dit qu'il sait à qui s'adresser. Apparemment, %noblehouse% est intéressé par l'ouverture de canaux, et ils apprécieraient %crowns% couronnes pour installer de nouvelles affaires. Civilisé en effet.}",
			Banner = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites en sorte que cela se produise.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous n'avons pas besoin de ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Vous acceptez les propositions du moine. Ensemble, vous rencontrez un intermédiaire et un des nobles lui-même. La réunion a lieu en secret et, au début, il y a beaucoup d'absurdités dramatiques de cape et d'épée. Des hommes vêtus de noir et gardant les mains sur leurs armes, des nobles qui chuchotent entre eux, mais une fois que tout est dit et fait... vous prenez un long verre ensemble. À l'avenir, %noblehouse% sera plus ouvert aux transactions.}",
			Banner = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faire du travail de mercenaire pour eux permettrait d'améliorer les relations.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Flags.set("IsRaidersRedemption", true);
				this.World.Assets.addBusinessReputation(50);
				this.World.Assets.addMoney(-2000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-2000[/color] Couronnes"
				});
				_event.m.NobleHouse.addPlayerRelation(20.0, "A été soudoyé pour avoir des relations avec vous");
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "Vos relations avec " + _event.m.NobleHouse.getName() + " s'améliorent"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 500)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 2500)
		{
			return;
		}

		if (this.World.Flags.get("IsRaidersRedemption"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates_nobles = [];

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() > 5.0 && n.getPlayerRelation() < 25.0)
			{
				candidates_nobles.push(n);
			}
		}

		if (candidates_nobles.len() == 0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" && bro.getLevel() > 1)
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates_nobles[this.Math.rand(0, candidates_nobles.len() - 1)];
		this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"crowns",
			"2,000"
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.NobleHouse = null;
	}

});

