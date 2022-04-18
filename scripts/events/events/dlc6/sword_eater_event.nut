this.sword_eater_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.sword_eater";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Un mangeur d\'épée danse autour d\'une place de %townname%. Il tend une lame à peu près aussi épaisse que votre petit doigt.%SPEECH_ON%Comme le Doreur me voit, je vais manger cet acier!%SPEECH_OFF%L\'homme annonce son intention et s\'exécute promptement : il se cambre, pince la lame, et la fait glisser dans sa bouche et ainsi de suite, sa bouche se plissant autour de l\'acier comme s\'il avalait des nouilles. La foule est d\'abord surprise, puis l\'avaleur fait deux pouces en l\'air et les spectateurs applaudissent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Bravo ! Voici quelques pièces pour vous.",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Bravo ! Donnez à ce gars quelques pièces de ma part, %wildman%.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				this.Options.push({
					Text = "Une façon intéressante de gagner sa vie.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous lancez quelques couronnes à l\'homme. Il sort son épée et place sa pointe sur son crâne. La foule applaudit à nouveau. L\'homme sourit et parle en équilibrant son épée. Je vois votre bannière, Mercenaire. Je ne suis pas un guerrier, mais je suis un voyageur et un bon orateur. Bien que je cherche à impressionner pour un gain personnel, je m\'assurerai à l\'occasion d\'avoir un mot gentil pour votre compagnie de marginaux à la recherche d\'argent.%SPEECH_OFF%L\'avaleur écarte les bras et hoche rapidement la tête. La lame s\'échappe de son crâne et tombe habilement dans son fourreau à la hanche. Une fois encore, la foule hurle de joie et on ne peut s\'empêcher de penser que cet artiste est un homme de parole.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mon épée n\'est pas si tranchante, mais les dames ne peuvent même pas faire ça ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-5);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]5[/color] Couronnes"
					}
				];
				_event.m.Town.getOwner().addPlayerRelation(5.0, "Des artistes locaux font parler de vous");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous tendez quelques couronnes à %wildman% et lui dites de donner un pourboire à l\'artiste. Il grogne et se dirige vers vous, puis vous réalisez que ce n\'est pas n\'importe quel compagnon que vous avez appelé, mais %wildman% le sauvageon ! Avant que vous ne puissiez l\'arrêter, il pousse l\'avaleur de sabres. Il y a des cris, des hurlements et des gargouillis de sang, mais la foule s\'avance devant l\'action et bloque la vue. On vous dit que la lame est sortie par le devant de l\'avaleur avec des morceaux d\'œsophage ou d\'estomac accrochés. Vous le savez, car le sauvageon s\'est assuré de rapporter l\'épée lui-même et vous avez dû la faire nettoyer. Comment exactement il a récupéré la lame pendant ces moments de carnage vous échappe, bien que vous imaginiez qu\'il a échappé à la férocité de la foule par sa seule volonté, sa détermination et son absence totale de jugements moraux qui effraient les hommes de sensibilité normale. Vous demandez à quelques mercenaires de cacher l\'homme sauvage car il aura besoin de faire profil bas pendant un certain temps.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon travail, mais aussi mauvais travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-5);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]5[/color] Couronnes"
					}
				];
				local item = this.new("scripts/items/weapons/fencing_sword");
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Town.getOwner().addPlayerRelation(-10.0, "La rumeur dit qu\'un artiste local a été tué par un de vos hommes.");
				this.World.Flags.set("IsSwordEaterWildmanDone", true);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 100)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (this.Const.DLC.Wildmen && !this.World.Flags.get("IsSwordEaterWildmanDone") && bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Wildman = null;
	}

});

