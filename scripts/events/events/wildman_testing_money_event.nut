this.wildman_testing_money_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		OtherGuy = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.wildman_testing_money";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_04.png[/img]Vous trouvez %wildman% le sauvageon qui empile ses couronnes pour former des tours. Il se penche sur ses manifestations d\'argent avec un large sourire, mais il se lance soudainement en avant, renversant les tours comme un enfant le ferait avec ses blocs. Il rit de façon maniaque tandis que les pièces s\'éparpillent. L\'homme qui joue avec son argent est un spectacle curieux. Peut-être que le sauvage n\'a aucune idée de ce à quoi servent les couronnes ? Si c\'est le cas, peut-être... peut-être que vous pourriez les reprendre ?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons s\'il va échanger tout ça contre autre chose.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Mieux vaut laisser l\'homme et ses couronnes tranquilles.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.getFlags().set("IsConceptionOfMoneyTested", true);
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]Vous vous accroupissez. %SPEECH_ON%Salut %wildman%. Je peux en prendre une ? %SPEECH_OFF%Avec précaution, vous prenez une pièce et mesurez la réaction du sauvageon. Il hausse les épaules et grogne comme pour dire \"c\'est à toi \". Vous prenez une autre couronne. Et puis une autre. Le sauvageon vous regarde fixement, mais vous produisez lentement un bâton avec un nœud à froufrous attaché au sommet. Sa nature tourbillonnante attire l\'attention du sauvageon. Quand il tend la main pour l\'attraper, vous la retirez et secouez la tête. Vous pointez alors les couronnes, puis le bâton.%SPEECH_ON% L\'un pour l\'autre, oui ? %SPEECH_OFF% Le sauvageon regarde ses couronnes, y réfléchissant comme un comptable, mais vous savez que ses pensées sont bien plus chaotiques que cela. Soudain, il grogne, pousse ses couronnes en avant et vous prend le bâton. On dirait que l\'échange est terminé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela s\'est bien passé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local money = 10 * _event.m.Wildman.getDaysWithCompany();
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Vous vous accroupissez et regardez le désordre des couronnes. %SPEECH_ON% Celles-ci sont vraiment brillantes, hein ? %SPEECH_OFF% Le sauvageon grogne et essaie de vous éloigner. Résistant, vous ramassez une couronne. Ses mains tombent et il lève la tête, vous regardant fixement. Lentement, vous posez la pièce de monnaie, puis vous produisez un bâton dont le sommet est entouré d\'une ficelle. Son regard se relâche, le solide bâton est une friandise pour le sauvageon débraillé. Vous lui faites signe que vous allez le lui donner en échange des couronnes. Il prend le bâton. Vous prenez les couronnes. Mais quand le sauvageon joue avec la corde, elle tombe et s\'envole dans le vent. Il s\'écrie, puis vous regarde d\'un air meurtrier, vous qui vous tenez là, les deux bras en tonneau pour essayer de tenir toutes les couronnes. Le sauvage hurle. Vous laissez tomber les couronnes et courez aussi vite que possible. Derrière vous, c\'est le chaos total : des outils et des armes cassés, des frères qui courent pour sauver leur vie, et le chaos absolu d\'une bande d\'hommes confus assaillis par un sauvage, mais vous n\'osez pas regarder.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je n\'aurais probablement pas dû faire ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.worsenMood(1.0, "A fait un mauvais échange");

				if (_event.m.Wildman.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}

				local injury = _event.m.OtherGuy.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.OtherGuy.getName() + " souffre de " + injury.getNameOnly()
				});

				if (_event.m.Item != null)
				{
					this.World.Assets.getStash().remove(_event.m.Item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + _event.m.Item.getIcon(),
						text = "Vous perdez " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman" && !bro.getFlags().get("IsConceptionOfMoneyTested"))
			{
				candidates.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.OtherGuy = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
		local items = this.World.Assets.getStash().getItems();
		local candidates = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary) || item.isIndestructible())
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				candidates.push(item);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Item = candidates[this.Math.rand(0, candidates.len() - 1)];
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.OtherGuy = null;
		this.m.Item = null;
	}

});

