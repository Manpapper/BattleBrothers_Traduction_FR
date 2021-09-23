this.terrifying_nightmares_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.terrifying_nightmares";
		this.m.Name = "Cauchemars Terrifiants";
		this.m.Description = "Les habitants de cette colonie sont terrorisés par les cauchemars. Beaucoup préfèrent rester éveillés toute la nuit, juste pour être en sécurité.";
		this.m.Icon = "ui/settlement_status/settlement_effect_25.png";
		this.m.Rumors = [
			"L\'autre jour, je suis passé par %settlement%. Quelque chose ne va pas là-bas. Des visages pâles, des yeux fatigués et des pas traînants. C\'est comme s\'ils n\'avaient pas dormi depuis une semaine !",
			"Je viens de recevoir une lettre de ma tante à %settlement% qui prétend que toute la ville est troublée par de terribles cauchemars. Je ne sais pas, elle a toujours été trop dramatique.",
			"La meilleure recette pour une bonne nuit de sommeil est de travailler dur et de boire une pinte de bière ! Maintenant que j\'y pense, quelqu\'un devrait le dire aux gens de %settlement% ; d\'après ce que j\'ai entendu, toute la ville a du mal à dormir."
		];
	}

	function getAddedString( _s )
	{
		return _s + " souffre de " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " ne souffre plus de " + this.m.Name;
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.75;
	}

});

