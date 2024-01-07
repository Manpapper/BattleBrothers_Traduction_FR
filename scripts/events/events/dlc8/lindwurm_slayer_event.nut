this.lindwurm_slayer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.lindwurm_slayer";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Vous êtes en train de boire un verre dans l\'une des confortables tavernes de %townname%. Naturellement, ce bien-être ne dure pas longtemps, car un homme entre avec son armure qui cliquette et tinte. Vous commettez l\'erreur de le regarder et d\'attirer son attention. Il se dirige immédiatement vers vous. Soupirant, vous mettez votre main sur votre épée et attendez la suite. L\'homme se dirige vers l\'extrémité de votre table et se redresse.%SPEECH_ON%Laissez-moi me présenter, au cas où la rumeur et le mythe ne l\'auraient pas déjà fait. Je suis %dragonslayer%. Mon choix de vie dans ce monde est de chasser et de tuer des dragons.%SPEECH_OFF%Vous prenez un verre et le posez, en disant à l\'homme que les dragons n\'existent pas. Il sourit. %SPEECH_ON% C\'est parce que mon père les a tous tués. En vérité, je suis un tueur de lindwurms, et j\'ai entendu dire que vous étiez le capitaine de la compagnie %companyname%, une unité de grande renommée. Que diriez-vous de combiner nos compétences et nos talents, hm? Je serais prêt à me joindre à vous pour %price% couronnes.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Très bien, je vais payer %price% couronnes.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Non merci.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"lindwurm_slayer_background"
				]);
			_event.m.Dude.getBackground().m.RawDescription = "{%name% est censé être un chasseur de monstres célèbre avec un talent particulier pour tuer des Lindwurms. Il prétend être le fils de Dirk le Tueur de Dragons, le chasseur de monstres qui aurait abattu le dernier dragon vivant.}";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.getItems().equip(this.new("scripts/items/weapons/fighting_spear"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/shields/buckler_shield"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/helmets/heavy_mail_coif"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/named/lindwurm_armor"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Vous et les Oathtakers êtes en train de marcher dans les rues de %townname% lorsqu\'un homme en armure étincelante, digne des Oathtakers, apparaît soudainement. Il se dirige vers vous, et malgré le fait que les membres de la compagnie dégainent leurs armes en guise d\'avertissement, l\'homme continue sans être inquiété et vous tend la main.%SPEECH_ON%Hail! Je suis %dragonslayer%, fils du plus célèbre dragonnier de tout le pays.%SPEECH_OFF% Vos hommes rengainent leurs armes et tout le monde regarde autour de lui. Vous serrez la main de l\'homme et lui demandez ce qu\'il veut. Il se recule, se redresse comme pour se présenter puis se vante de ses exploits: il a tué des monstres de toutes tailles, des femmes de toutes tailles. Il a un penchant particulier pour les dragons et un autre pour les grandes filles parce qu\'elles lui rappellent... Vous l\'interrompez, lui disant que les dragons n\'existent plus. Il hoche la tête. %SPEECH_ON%C\'est exact ! Les dragons n\'existent plus, car mon père est celui qui a tué le dernier. Je vais être honnête, je suis un tueur de lindwurm, et je suis plutôt bon dans ce domaine. J\'ai cherché à vous rencontrer, vous, les Oathtakers, car votre renommée n\'est plus à faire et je souhaite en faire partie.%SPEECH_OFF%Ce soi-disant célèbre tueur de lindwurm souhaite rejoindre gratuitement la compagnie %companyname%.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Très bien, rejoignez-nous.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Non merci",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"lindwurm_slayer_background"
				]);
			_event.m.Dude.getBackground().m.RawDescription = "{%name% est censé être un célèbre chasseur de monstres avec un talent particulier pour tuer des Lindwurms. Il prétend être le fils de Dirk le Tueur de Dragons, le chasseur de monstres qui aurait abattu le dernier dragon vivant.}";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.getItems().equip(this.new("scripts/items/weapons/fighting_spear"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/shields/buckler_shield"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/helmets/heavy_mail_coif"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/named/lindwurm_armor"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Vous fouillez dans vos poches et posez la bourse sur la table. L\'homme la prend en main, l\'ouvre, compte la monnaie, il hoche la tête et referme le tout.%SPEECH_ON%Très bien capitaine, je me joins à vous et à la compagnie %companyname%. Je jure sur la tombe de mon père que vous ne le regretterez pas.%SPEECH_OFF%.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-5000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]5000[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Soit il se montrera à la hauteur de ce qu\'il a accompli, soit il finira en charpie. S\'il est prêt à se joindre à vous sans frais, qu\'est-ce que ça peut faire qu\'il soit bon ou pas? Vous tendez votre main et l\'homme la serre. Son armure tinte et cliquette tandis que son bras rebondit de haut en bas.%SPEECH_ON%Vos Oathtakers ne seront pas déçus, je peux vous le promettre.%SPEECH_OFF%.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie, %dragonslayer%.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 2000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 6000 && this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dragonslayer",
			this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"price",
			"5000"
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
		{
			return "B";
		}

		return "A";
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

