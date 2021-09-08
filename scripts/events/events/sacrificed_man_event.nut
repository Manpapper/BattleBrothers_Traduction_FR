this.sacrificed_man_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Other = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.sacrificed_man";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Un spectacle étrange : un homme mort cloué au sol par des lances. Son propre sang a été utilisé pour entourer son cadavre et d\'autres rites rituels étranges ont été peints à l\'aide de son sang. %otherbrother% commence à récupérer les lances. Vous essayez de lui dire d\'arrêter, mais c\'est déjà trop tard. Il brandit une des armes.%SPEECH_ON%Quoi ? Elles sont de bonne qualité. Pourquoi les laisserions-nous ici?%SPEECH_OFF%Eh bien, s\'il y avait une protection divine ici, elle a déjà été brisée. Vous ramassez les lances.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Repose en paix.",
					function getResult( _event )
					{
						if (_event.m.Cultist != null)
						{
							return "Cultist";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "%terrainImage%Avant que vous puissiez partir, %cultist% se penche vers l\'homme sacrifié et lui chuchote à l\'oreille. Un instant plus tard, la tête de l\'homme mort vacille. Ses yeux s\'élargissent et ses narines se dilatent. Le cultiste vous regarde.%SPEECH_ON%Il n\'était pas mort. Son sang a été utilisé pour rassasier Davkul. Si nous avions eu besoin de sa mort, nous l\'aurions brûlé.%SPEECH_OFF%Il fait une pause et se tourne vers l\'homme dont les blessures guérissent mystérieusement sous vos yeux comme de la boue qui remplit une empreinte de pas. L\'homme non sacrifié saute sur ses pieds et se tourne instinctivement vers vous.%SPEECH_ON%Si vous le permettez, je me battrai pour vous et, ce faisant, je répandrai la foi de Davkul.%SPEECH_OFF%Sa voix est robotique, comme s\'il avait passé l\'année dernière à répéter le serment.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans %companyname% alors.",
					function getResult( _event )
					{
						return "Recruit";
					}

				},
				{
					Text = "Je n\'ai vraiment pas besoin de plus d\'hommes. Débrouille-toi tout seul.",
					function getResult( _event )
					{
						return "Deny";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
				_event.m.Dude.setTitle("the Sacrifice");
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé cet homme en tant que sacrifice, mais il s\'est relevé de son destin pour être un serviteur de Davkul. Il a demandé à se battre pour vous, et vous, pour une raison quelconque, avez accepté.";
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

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Recruit",
			Text = "%terrainImage%Vous décidez d\'embarquer l\'homme. %otherbrother% se tient au bord du chemin, une paire de lances à la main.%SPEECH_ON%On les prend toujours, n\'est-ce pas ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien sûr que oui.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Cultist.improveMood(1.0, "Vous avez recruté un camarade cultiste");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Deny",
			Text = "%terrainImage%Vous reniez le cultiste ressuscité. Il hoche la tête.%SPEECH_ON%Bien sûr. Je trouverai d\'autres moyens de servir Davkul. Adieu, monsieur.%SPEECH_OFF% Il s\'incline devant %cultist% avant de se retourner et de partir. %otherbrother% se tient là avec deux lances à la main.%SPEECH_ON% On les prend toujours, non ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien sûr que oui.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Cultist.worsenMood(1.0, "Vous n\'avez pas réussi à recruter un camarade cultistes");

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 6 && d <= 12)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cultist = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates_cultist.push(bro);
			}
			else if (bro.getBackground().getID() != "background.slave")
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		if (candidates_cultist.len() != 0)
		{
			this.m.Cultist = candidates_cultist[this.Math.rand(0, candidates_cultist.len() - 1)];
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Other = null;
		this.m.Dude = null;
	}

});

